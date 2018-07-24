//
//  HostDashboardTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class HostDashboardTableViewController: UITableViewController {
    
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostSinceDateLabel: UILabel!
    @IBOutlet weak var ytdEarningsLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!

    override func viewDidLoad() {
        if let firstName = UserDefaults.standard.string(forKey: "user_firstname"),
            let lastName = UserDefaults.standard.string(forKey: "user_lastname") {
            hostNameLabel.text = "\(firstName) \(lastName)".capitalized
        }
        if let token = UserDefaults.standard.string(forKey: "token") {
            User.getHostSinceDate(withToken: token) { error, datestring in
                if let datestring = datestring {
                    self.hostSinceDateLabel.text = datestring
                }
            }
        }
    }

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
