//
//  VehicleTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class VehicleListTableViewController: UITableViewController {

    var vehicles = [Vehicle]()

    func initializeSettings() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func initializeAppearanceSettings() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()

        User.getCurrentUserVehicles() { vehicles in
            if let vehicles = vehicles {
                self.vehicles = vehicles
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // reload data every time view appears because
        // if the user chooses to make a different vehicle
        // their current vehicle, this tableview needs
        // to be updated to reflect that change.
        tableView.reloadData()
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapViewController", sender: self)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "vehicleCell") as! VehicleTableViewCell
        let vehicle = vehicles[indexPath.row]
        cell.makeAndModelLabel.text = "\(vehicle.make) \(vehicle.model)"
        cell.vehicleColorLabel.text = vehicle.color
        cell.licencePlateLabel.text = vehicle.licensePlate
        let currentVehicleID = UserDefaults.standard.integer(forKey: "vehicle_id")
        if currentVehicleID == vehicle.id {
            cell.currentVehicleIndicatorLabel.isHidden = false
        } else {
            cell.currentVehicleIndicatorLabel.isHidden = true
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVehicleDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let vehicleDetailTableViewController =
                    segue.destination as? VehicleDetailTableViewController {
                    vehicleDetailTableViewController.vehicle = vehicles[selectedRow]
                }
            }
        }
    }

}
