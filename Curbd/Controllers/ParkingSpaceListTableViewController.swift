//
//  ParkingSpaceListTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 6/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class ParkingSpaceListTableViewController: UITableViewController {

    var parkingSpaces = [ParkingSpace]()
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: defaultLoadingStyle, color: .white, padding: nil)

    func initializeSettings() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func initializeAppearanceSettings() {
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            if parkingSpaces.isEmpty {
                startLoading()
            }
            User.getHostParkingSpaces(withToken: token) { error, parkingSpaces in
                self.stopLoading()
                if let parkingSpaces = parkingSpaces {
                    self.parkingSpaces = parkingSpaces
                    if self.parkingSpaces.isEmpty {
                        self.tableView.backgroundView = EmptyTableView(frame: self.tableView.frame)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingSpaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "parkingSpaceCell") as! ParkingSpaceTableViewCell
        let parkingSpace = parkingSpaces[indexPath.row]

        cell.parkingSpaceNameLabel.text = parkingSpace.name

        if parkingSpace.is_active {
            cell.parkingSpaceIsActiveLabel.text = "Active"
            cell.parkingSpaceIsActiveLabel.textColor = UIColor.systemGreen
        } else {
            cell.parkingSpaceIsActiveLabel.text = "Inactive"
            cell.parkingSpaceIsActiveLabel.textColor = UIColor.systemGray
        }

        let parkingSpaceLocation = CLLocation(
            latitude: parkingSpace.latitude,
            longitude: parkingSpace.longitude)
        print(parkingSpaceLocation)
        cell.mapView.centerOn(location: parkingSpaceLocation, regionRadius: 500)

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(
            parkingSpace.latitude,
            parkingSpace.longitude)
        cell.mapView.addAnnotation(annotation)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
            if error == nil {
                if  let city = placemarks?[0].locality,
                    let state = placemarks?[0].administrativeArea {
                    cell.parkingSpaceCityAndStateLabel.text = "\(city), \(state)"
                }
            }
        }


        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParkingSpaceDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let parkingSpaceDetailTableViewController =
                    segue.destination as? ParkingSpaceDetailTableViewController {
                    parkingSpaceDetailTableViewController.parkingSpace =
                        parkingSpaces[selectedRow]
                }
            }
        }
    }

    @IBAction func unwindToParkingSpacesListAfterModifying(segue:UIStoryboardSegue) {
        startLoading()
    }

    func startLoading() {
        navigationItem.titleView = activityIndicator
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        navigationItem.titleView = nil
        navigationItem.title = "Listings"
    }
}

