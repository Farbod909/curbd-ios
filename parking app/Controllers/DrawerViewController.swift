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
    @IBOutlet weak var arriveDisplayTitle: UILabel!
    @IBOutlet weak var arriveDisplayLabel: UILabel!
    @IBOutlet weak var arriveLeaveSeperator: UIView!
    @IBOutlet weak var leaveDisplayTitle: UILabel!
    @IBOutlet weak var leaveDisplayLabel: UILabel!
    @IBOutlet weak var editTimesButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var matchingItems = [MKMapItem]() // I'm not sure what this is?
    var arriveDate = Date()
    var leaveDate = Date(timeInterval: 7200, since: Date())

    let partialRevealHeight: CGFloat = 183
    let collapsedHeight: CGFloat = 300
    let drawerPositions: [PulleyPosition] = [
        .open,
        .partiallyRevealed,
        // not supporting .collapsed
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

        self.arriveDisplayLabel.text = self.arriveDate.toHumanReadable()
        self.leaveDisplayLabel.text = self.leaveDate.toHumanReadable()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    func hideSearchFields() {
        self.searchField.isHidden = true
        self.arriveDisplayTitle.isHidden = true
        self.leaveDisplayTitle.isHidden = true
        self.arriveDisplayLabel.isHidden = true
        self.leaveDisplayLabel.isHidden = true
        self.arriveLeaveSeperator.isHidden = true
        self.editTimesButton.isHidden = true
    }

    func unhideSearchFields() {
        self.searchField.isHidden = false
        self.arriveDisplayTitle.isHidden = false
        self.leaveDisplayTitle.isHidden = false
        self.arriveDisplayLabel.isHidden = false
        self.leaveDisplayLabel.isHidden = false
        self.arriveLeaveSeperator.isHidden = false
        self.editTimesButton.isHidden = false
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
        self.arriveDisplayLabel.text = self.arriveDate.toHumanReadable()

        self.leaveDate = arriveLeaveVC.leaveDate
        self.leaveDisplayLabel.text = self.leaveDate.toHumanReadable()

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController
        mapVC.locateParkingSpacesOnCurrentMapArea(
            from: self.arriveDate,
            to: self.leaveDate,
            alertIfNotFound: false,
            selectFirstResult: false)
    }
}

extension DrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return drawerPositions
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if  iphoneX {
            return partialRevealHeight + 26
        }
        return partialRevealHeight
    }

    func collapsedDrawerHeight() -> CGFloat {
        if  iphoneX {
            return collapsedHeight + 26
        }
        return collapsedHeight
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .partiallyRevealed {
            self.searchResultsTableView.isHidden = true
            searchField.resignFirstResponder()
        } else if drawer.drawerPosition == .open {
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
        searchField.text = searchResults[indexPath.row].title

        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearchRequest(completion: completion)
        let mapSearch = MKLocalSearch(request: searchRequest)
        mapSearch.start { response, error in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else {
                let coordinate = (response?.mapItems[0].placemark.coordinate)!
                mapVC.mapView.centerOn(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))

                mapVC.locateParkingSpacesOnCurrentMapArea(
                    from: self.arriveDate,
                    to: self.leaveDate,
                    alertIfNotFound: true,
                    selectFirstResult: true)
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
