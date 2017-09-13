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

class DrawerViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var searchResultsTableView: UITableView!

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    var matchingItems: [MKMapItem] = [MKMapItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    func performSearch() {

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController

        matchingItems.removeAll()
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchField.text
        request.region = mapVC.mapView.region

        let search = MKLocalSearch(request: request)

        search.start(completionHandler: {(response, error) in

            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")

                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")

                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    mapVC.mapView.addAnnotation(annotation)
                }
            }
        })
    }
}

extension DrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open, .partiallyRevealed, .collapsed]
    }

    func partialRevealDrawerHeight() -> CGFloat {
        return 68
    }

    func collapsedDrawerHeight() -> CGFloat {
        return 264
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition != .open {
            searchField.resignFirstResponder()
        }
    }

}

extension DrawerViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .open)
        }
    }

    func searchFieldDidChange(_ textField: UITextField) {
        searchCompleter.queryFragment = textField.text!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .collapsed)
        }
        performSearch()
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

        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
//            let coordinate = response?.mapItems[0].placemark.coordinate
//            print(String(describing: coordinate))
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")

                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")

                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    mapVC.mapView.addAnnotation(annotation)
                }
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
