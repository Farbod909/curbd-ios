//
//  VehicleTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class VehicleTableViewController: UITableViewController {

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

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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
        if let currentVehicleLicensePlate = UserDefaults.standard.string(
            forKey: "vehicle_license_plate") {
            if currentVehicleLicensePlate == vehicle.licensePlate {
                cell.currentVehicleIndicatorLabel.isHidden = false
            }
        }
        return cell
    }
}
