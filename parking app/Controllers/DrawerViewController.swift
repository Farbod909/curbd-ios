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

    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var arriveDisplayLabel: UILabel!
    @IBOutlet weak var leaveDisplayLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var matchingItems = [MKMapItem]() // I'm not sure what this is?
    var arriveDate = Date()
    var leaveDate = Date()

    let partiallyRevealedDrawerHeight: CGFloat = 183
    let drawerPositions = [
        PulleyPosition.open,
        PulleyPosition.partiallyRevealed
        // not supporting PulleyPosition.collapsed
    ]

    func initializeSettings() {
        initializeAppearanceSettings()

        searchCompleter.delegate = self

        searchField.delegate = self
        searchField.addTarget(
            self, action: #selector(DrawerViewController.searchFieldDidChange(_:)),
            for: UIControlEvents.editingChanged)

        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }

    func initializeAppearanceSettings() {
        searchField.backgroundColor = UIColor.clear.withAlphaComponent(0.08)
        searchField.layer.cornerRadius = 8
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 0
        let searchFieldPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: self.searchField.frame.height))
        searchField.leftView = searchFieldPaddingView
        searchField.leftViewMode = UITextFieldViewMode.always

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        self.arriveDisplayLabel.text = humanReadableDate(self.arriveDate)
        self.leaveDisplayLabel.text = humanReadableDate(self.leaveDate)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArriveLeaveVC" {
            if let viewController = segue.destination as? ArriveLeaveViewController {
                viewController.arriveDate = self.arriveDate
                viewController.leaveDate = self.leaveDate
            }
        }
    }

    @IBAction func unwindToDrawerViewController(segue: UIStoryboardSegue) {
        let arriveLeaveVC = segue.source as! ArriveLeaveViewController

        self.arriveDate = arriveLeaveVC.arriveDate
        self.arriveDisplayLabel.text = humanReadableDate(self.arriveDate)

        self.leaveDate = arriveLeaveVC.leaveDate
        self.leaveDisplayLabel.text = humanReadableDate(self.leaveDate)
    }
}

extension DrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return drawerPositions
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if  UIDevice().userInterfaceIdiom == .phone &&
            UIScreen.main.nativeBounds.height == 2436 {
            // iPhone X
            return partiallyRevealedDrawerHeight + 26
        }
        return partiallyRevealedDrawerHeight
    }

    func collapsedDrawerHeight() -> CGFloat {
        // We're not supporting this position but the function
        // has to stay to conform to protocol.
        return 0
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
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else {
                let coordinate = (response?.mapItems[0].placemark.coordinate)!
                ParkingSpace.findSpaces(
                    bl_lat: coordinate.latitude-1,
                    bl_long: coordinate.longitude-1,
                    tr_lat: coordinate.latitude+1,
                    tr_long: coordinate.longitude+1,
                    from: self.arriveDate,
                    to: self.leaveDate
                ) { parkingSpaces in
                    // annotate each parkingSpace on the map
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
