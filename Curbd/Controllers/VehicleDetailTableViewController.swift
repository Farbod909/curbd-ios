//
//  VehicleDetailTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/18/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class VehicleDetailTableViewController: UITableViewController {

    @IBOutlet weak var vehicleYearCell: UITableViewCell!
    @IBOutlet weak var vehicleMakeCell: UITableViewCell!
    @IBOutlet weak var vehicleModelCell: UITableViewCell!
    @IBOutlet weak var vehicleColorCell: UITableViewCell!
    @IBOutlet weak var vehicleSizeCell: UITableViewCell!
    @IBOutlet weak var vehicleLicensePlateCell: UITableViewCell!

    var vehicle: Vehicle?

    override func viewDidLoad() {
        if let vehicle = vehicle {
            title = vehicle.make.capitalized + " " + vehicle.model.capitalized

            vehicleYearCell.detailTextLabel?.text = String(describing: vehicle.year)
            vehicleMakeCell.detailTextLabel?.text = vehicle.make
            vehicleModelCell.detailTextLabel?.text = vehicle.model
            vehicleColorCell.detailTextLabel?.text = vehicle.color
            vehicleSizeCell.detailTextLabel?.text = vehicle.sizeDescription
            vehicleLicensePlateCell.detailTextLabel?.text = vehicle.licensePlate
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // selected 'Make Current Vehicle'
                vehicle?.setAsCurrentVehicle()
                navigationController?.popViewController(animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // selected 'Delete Vehicle'
                presentConfirmationAlert(
                    title: "Are You Sure?",
                    message: "Are you sure you would like to delete this vehicle?") { action in
                        // user confirmed deletion
                        if  let token = UserDefaults.standard.string(forKey: "token"),
                            let vehicle = self.vehicle {
                            vehicle.delete(withToken: token) { error in
                                if error == nil {
                                    if vehicle.isCurrentVehicle() {
                                        Vehicle.unsetCurrentVehicle()
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.presentServerErrorAlert()
                                }
                            }
                        }
                }
                tableView.deselectRow(at: indexPath, animated: true)

            }
        }
    }
    
}
