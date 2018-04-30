//
//  VehicleDetailTableViewController.swift
//  parking app
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
            vehicleSizeCell.detailTextLabel?.text = vehicle.sizeString
            vehicleLicensePlateCell.detailTextLabel?.text = vehicle.licensePlate
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // selected 'Make Current Vehicle'
                if let vehicle = vehicle {
                    vehicle.saveToUserDefaults()
                }
                navigationController?.popViewController(animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // selected 'Delete Vehicle'

                // first ask 'are you sure?'
                // if yes, then delete
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
