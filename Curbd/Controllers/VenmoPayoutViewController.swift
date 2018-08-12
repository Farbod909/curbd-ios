//
//  VenmoPayoutViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/5/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class VenmoPayoutViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var venmoEmailPhoneCell: UITableViewCell!
    @IBOutlet weak var venmoEmailPhoneTextField: UITextField!
    @IBOutlet weak var payoutButton: UITableViewCell!

    var payoutAmount: Int? // in US cents

    var venmoEmail: String?
    var venmoPhone: String?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let payoutAmount = payoutAmount, payoutAmount > 0 {
            payoutButton.isUserInteractionEnabled = true
            payoutButton.textLabel?.textColor = UIColor(hex: "21BB2A")
        }

        venmoEmailPhoneCell.selectionStyle = .none

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClick(_:)))

        if let venmoEmail = venmoEmail {
            venmoEmailPhoneTextField.text = venmoEmail
        } else if let venmoPhone = venmoPhone {
            venmoEmailPhoneTextField.text = venmoPhone
        }

        if let payoutAmount = payoutAmount {
            payoutButton.textLabel?.text = "Request \(payoutAmount.toUSDRepresentation()) Payout"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                if let token = UserDefaults.standard.string(forKey: "token") {
                    PaymentClient.requestVenmoPayout(
                        withToken: token,
                        venmoEmail: venmoEmailPhoneTextField.text) { error in

                            if error == nil {
                                self.presentSingleButtonAlert(title: "Request Sent", message: "Your request has been sent. Please allow one business day for your request to be processed. Thank you.") { _ in
                                    self.performSegue(withIdentifier: "unwindToHostDashboardViewController", sender: self)
                                }
                            } else {
                                self.presentServerErrorAlert()
                            }

                    }

                }
            }
        }
    }

    @objc func cancelButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToHostDashboardViewController", sender: self)
    }
}
