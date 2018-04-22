//
//  SearchDrawerViewController.swift
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

class SearchDrawerViewController: UIViewController {

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
    // round up to nearest 5 minutes
    var arriveDate = Date().ceil(precision: 300)
    var leaveDate = Date(timeInterval: 7200, since: Date()).ceil(precision: 300)

    let partiallyRevealedHeight: CGFloat = 183
    let collapsedHeight: CGFloat = 300
    let drawerPositions: [PulleyPosition] = [
        .open,
        .partiallyRevealed,
        // not supporting .collapsed
    ]

    func initializeSettings() {

        searchCompleter.delegate = self

        searchField.delegate = self
        searchField.addTarget(
            self, action: #selector(SearchDrawerViewController.searchFieldDidChange(_:)),
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
            frame: CGRect(x: 0, y: 0, width: 10, height: searchField.frame.height))
        searchField.leftView = searchFieldPaddingView
        searchField.leftViewMode = UITextFieldViewMode.always

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()

        // TODO: Possibly implement reactive labels
        arriveDisplayLabel.text = arriveDate.toHumanReadable()
        leaveDisplayLabel.text = leaveDate.toHumanReadable()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let pulleyViewController = parent as? PulleyViewController {
            // set initial drawer position to .partiallyRevealed
            pulleyViewController.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArriveLeaveVC" {
            if let arriveLeaveViewController = segue.destination as? ArriveLeaveViewController {
                // set the arrive and leave dates of the arriveLeaveViewController
                // based on the arrive leave dates of the current view controller.
                arriveLeaveViewController.arriveDate = arriveDate
                arriveLeaveViewController.leaveDate = leaveDate

                // this is so that the arriveLeaveViewController can have a
                // translucent background
                arriveLeaveViewController.modalPresentationStyle = .overCurrentContext
            }
        }
    }

    /**
     This function is called when another view controller unwinds back
     to this view controller. If the source is `ArriveLeaveViewController`,
     set the current view controller's arrive date and leave date to
     whatever arrive and leave date that was set by the source
     `ArriveLeaveViewController`.

     This function also searches for parking spaces in the currently
     visible map area with the newly set arrive and leave dates.
     */
    @IBAction func unwindToSearchDrawerViewController(segue: UIStoryboardSegue) {
        if let arriveLeaveViewController = segue.source as? ArriveLeaveViewController {
            arriveDate = arriveLeaveViewController.arriveDate
            arriveDisplayLabel.text = arriveDate.toHumanReadable()

            leaveDate = arriveLeaveViewController.leaveDate
            leaveDisplayLabel.text = leaveDate.toHumanReadable()

            if let mapViewController = parent?.childViewControllers[0] as? MapViewController {
                mapViewController.locateParkingSpacesOnCurrentMapArea(
                    from: arriveDate,
                    to: leaveDate,
                    alertIfNotFound: false,
                    selectFirstResult: false)
            }
        }
    }
}

extension SearchDrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return drawerPositions
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if iphoneX {
            return partiallyRevealedHeight + 26
        }
        return partiallyRevealedHeight
    }

    func collapsedDrawerHeight() -> CGFloat {
        if iphoneX {
            return collapsedHeight + 26
        }
        return collapsedHeight
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .partiallyRevealed {
            searchResultsTableView.isHidden = true
            searchField.resignFirstResponder()
        } else if drawer.drawerPosition == .open {
            searchResultsTableView.isHidden = false
        }
    }
}

extension SearchDrawerViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.setDrawerPosition(position: .open)
        }
    }

    @objc func searchFieldDidChange(_ textField: UITextField) {
        searchCompleter.queryFragment = textField.text!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.setDrawerPosition(position: .partiallyRevealed)
        }
        return true
    }

}

extension SearchDrawerViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }

}

extension SearchDrawerViewController: UITableViewDelegate {

    /**
     This function changes the drawer to the partially revealed position
     and relocates the visible map area to the selected address. Then, it
     performs a search for parking spaces on the currently visible map area.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchField.resignFirstResponder()
        searchField.text = searchResults[indexPath.row].title

        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.setDrawerPosition(position: .partiallyRevealed)
        }

        let mapViewController = parent?.childViewControllers[0] as! MapViewController
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearchRequest(completion: completion)
        let mapSearch = MKLocalSearch(request: searchRequest)
        mapSearch.start { response, error in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else {
                let coordinate = (response?.mapItems[0].placemark.coordinate)!
                mapViewController.mapView.centerSlightlyBelow(location: CLLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude))
                mapViewController.locateParkingSpacesOnCurrentMapArea(
                    from: self.arriveDate,
                    to: self.leaveDate,
                    alertIfNotFound: true,
                    selectFirstResult: true)
            }
        }
    }
    
}

extension SearchDrawerViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.backgroundColor = UIColor.clear
        return cell
    }

}
