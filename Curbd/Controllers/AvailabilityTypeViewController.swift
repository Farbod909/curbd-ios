//
//  AvailabilityTypeViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/20/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class AvailabilityTypeViewController: UITableViewController {

    var parkingSpace: ParkingSpace?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let availabilityViewController = segue.destination as? AddRepeatingAvailabilityViewController {
            availabilityViewController.parkingSpace = parkingSpace
        }

        if let availabilityViewController = segue.destination as? AddFixedAvailabilityViewController {
            availabilityViewController.parkingSpace = parkingSpace
        }
    }
    
}
