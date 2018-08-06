//
//  VenmoPayoutViewController.swift
//  parking app
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

    override func viewDidLoad() {
        super.viewDidLoad()

        venmoEmailPhoneCell.selectionStyle = .none

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClick(_:)))

        if let venmoEmail = venmoEmail {
            venmoEmailPhoneTextField.text = venmoEmail
        } else if let venmoPhone = venmoPhone {
            venmoEmailPhoneTextField.text = venmoPhone
        }

        if let payoutAmount = payoutAmount {
            payoutButton.textLabel?.text = "Request $\(Double(payoutAmount)/100.00) Payout"
        }
    }

    @objc func cancelButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToHostDashboardViewController", sender: self)
    }
}
