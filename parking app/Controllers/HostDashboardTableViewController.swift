//
//  HostDashboardTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class HostDashboardTableViewController: UITableViewController {
    
    @IBAction func dismissButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageReservationsSegue" {
            let reservationListTableViewController = segue.destination as! ReservationListTableViewController
            reservationListTableViewController.isHost = true
        }
    }
    
}
