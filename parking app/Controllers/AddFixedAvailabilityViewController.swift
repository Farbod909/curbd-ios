//
//  AddAvailabilityViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka

class AddFixedAvailabilityViewController: FormViewController {

    var parkingSpace: ParkingSpace?

    func initializeSettings() {
        animateScroll = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done", style: .done, target: self, action: #selector(doneButtonClick))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        DateTimeInlineRow.defaultCellSetup = { cell, row in
            row.minuteInterval = 5
            row.minimumDate = Date().ceil(precision: 300)
        }

        form
            +++ Section("Time Range")
            <<< DateTimeInlineRow("from"){
                $0.title = $0.tag?.capitalized
                $0.value = Date().ceil(precision: 300)
            }
            <<< DateTimeInlineRow("until"){
                $0.title = $0.tag?.capitalized
                $0.value = Date(timeInterval: 7200, since: Date()).ceil(precision: 300)
            }

            +++ DecimalRow("pricing"){
                $0.useFormatterDuringInput = true
                $0.title = "Price Per Hour"
                $0.value = 1
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }

    }

    @objc func doneButtonClick(_ sender: UIBarButtonItem) {

        if  let start = (form.rowBy(tag: "from") as! DateTimeInlineRow).value,
            let end = (form.rowBy(tag: "until") as! DateTimeInlineRow).value,
            let pricing = (form.rowBy(tag: "pricing") as! DecimalRow).value,
            let parkingSpace = parkingSpace,
            let token = UserDefaults.standard.string(forKey: "token") {

            FixedAvailability.create(withToken: token, parkingSpace: parkingSpace, start: start, end: end, pricing: Int(pricing * 100)) { error, fixedAvailability in

                if let error = error {
                    self.presentServerErrorAlert()
                } else {
                    self.performSegue(withIdentifier: "unwindToParkingSpaceDetailTableViewController", sender: self)
                }
                if error == nil {
                } else {
                    self.presentServerErrorAlert()
                }

            }
        }
    }
}

