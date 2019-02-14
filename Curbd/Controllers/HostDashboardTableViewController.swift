//
//  HostDashboardTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class HostDashboardTableViewController: UITableViewController {

    var hostInfo: HostInfo?
    
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostSinceDateLabel: UILabel!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let firstName = UserDefaults.standard.string(forKey: "user_firstname"),
            let lastName = UserDefaults.standard.string(forKey: "user_lastname") {
            hostNameLabel.text = "\(firstName) \(lastName)".capitalized
        }
        if let token = UserDefaults.standard.string(forKey: "token") {
            User.getHostInfo(withToken: token) { error, hostInfo in
                if let hostInfo = hostInfo {
                    self.hostInfo = hostInfo
                    self.hostSinceDateLabel.text = hostInfo.hostSince
                    self.totalEarningsLabel.text = hostInfo.totalEarnings.toUSDRepresentation()
                    self.currentBalanceLabel.text = hostInfo.currentBalance.toUSDRepresentation()
                    self.availableBalanceLabel.text = hostInfo.availableBalance.toUSDRepresentation()
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

    @IBAction func unwindToHostDashboardViewController(segue:UIStoryboardSegue) { }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                if let hostInfo = hostInfo {
                    if hostInfo.hasAddress && hostInfo.hasDateOfBirth {
                        let venmoPayoutViewController = UIStoryboard(
                            name: "Main",
                            bundle: nil).instantiateViewController(withIdentifier: "venmoPayoutViewController") as! VenmoPayoutViewController

                        venmoPayoutViewController.venmoEmail = hostInfo.venmoEmail
                        venmoPayoutViewController.venmoPhone = hostInfo.venmoPhone
                        let balanceString = String((availableBalanceLabel.text?.dropFirst())!)
                        venmoPayoutViewController.payoutAmount = Int(Double(balanceString)! * 100)

                        show(venmoPayoutViewController, sender: self)
                    } else {

                        let hostInfoGatherViewController = UIStoryboard(
                            name: "Main",
                            bundle: nil).instantiateViewController(withIdentifier: "hostInfoGatherViewController") as! HostInfoGatherViewController

                        hostInfoGatherViewController.hostInfo = hostInfo
                        let balanceString = String((availableBalanceLabel.text?.dropFirst())!)
                        hostInfoGatherViewController.payoutAmount = Int(Double(balanceString)! * 100)

                        show(hostInfoGatherViewController, sender: self)

                    }

                }
            }
        }
    }
    
}
