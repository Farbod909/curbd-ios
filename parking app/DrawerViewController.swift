//
//  DrawerViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 9/12/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import Pulley
import MapKit
import Alamofire
import SwiftyJSON


class DrawerViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var arriveDisplayLabel: UILabel!
    @IBOutlet weak var leaveDisplayLabel: UILabel!

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var arriveDatetimeString: String = ""
    var leaveDatetimeString: String = ""

    func initializeSettings() {
        searchField.backgroundColor = UIColor.clear.withAlphaComponent(0.08)
        searchField.layer.cornerRadius = 8
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 0
        let searchFieldPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: self.searchField.frame.height))
        searchField.leftView = searchFieldPaddingView
        searchField.leftViewMode = UITextFieldViewMode.always

        searchCompleter.delegate = self
        searchField.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self

        searchField.addTarget(self, action: #selector(DrawerViewController.searchFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:'00'"
        self.arriveDatetimeString = dateFormatter.string(from: now)
        self.leaveDatetimeString = dateFormatter.string(from: now)
        self.arriveDisplayLabel.text = humanReadableDate(self.arriveDatetimeString)
        self.leaveDisplayLabel.text = humanReadableDate(self.leaveDatetimeString)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }
}

extension DrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open, .partiallyRevealed] // not supporting .collapsed
    }

    func partialRevealDrawerHeight() -> CGFloat {
        let height: CGFloat = 183
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                // iPhone X
                return height + 26
            }
        }
        return height
    }

    func collapsedDrawerHeight() -> CGFloat {
        // We're not supporting this position but the function
        // has to stay to conform to protocol
        return 264
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .partiallyRevealed {
            self.searchResultsTableView.isHidden = true
            searchField.resignFirstResponder()
        } else {
            self.searchResultsTableView.isHidden = false
        }
    }
}

extension DrawerViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .open)
        }
    }

    @objc func searchFieldDidChange(_ textField: UITextField) {
        searchCompleter.queryFragment = textField.text!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
        return true
    }

}

extension DrawerViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }

}

extension DrawerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        searchField.resignFirstResponder()
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .collapsed)
        }

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else {
                let coordinate = (response?.mapItems[0].placemark.coordinate)!
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//
//                annotation.title = response?.mapItems[0].name
//                mapVC.mapView.addAnnotation(annotation)

                let parameters: Parameters = [
                    "lat": coordinate.latitude,
                    "long": coordinate.longitude,
                    "radius": 10,
                    "start": self.arriveDatetimeString,
                    "end": self.leaveDatetimeString,
                ]

                print(coordinate.latitude)
                print(coordinate.longitude)

                Alamofire.request("http://localhost:8000/parking/nearby_spaces", parameters: parameters, encoding: URLEncoding.queryString).responseJSON { response in
                    let nearbyParkingSpaces = JSON(response.result.value!)

                    print(nearbyParkingSpaces)

                    for (_, parkingSpace):(String, JSON) in nearbyParkingSpaces {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(
                            latitude: parkingSpace["latitude"].doubleValue,
                            longitude: parkingSpace["longitude"].doubleValue)
                        mapVC.mapView.addAnnotation(annotation)
                    }

                }

                mapVC.centerMapOnLocation(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
    }
    
}

extension DrawerViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.backgroundColor = UIColor.clear
        return cell
    }

}
