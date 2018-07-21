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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        form
            +++ Section("Time Range")
            <<< DateTimeInlineRow("from"){
                $0.title = $0.tag?.capitalized
                $0.value = Date()
            }
            <<< DateTimeInlineRow("until"){
                $0.title = $0.tag?.capitalized
                $0.value = Date()
            }

            +++ DecimalRow("price per hour"){
                $0.useFormatterDuringInput = true
                $0.title = $0.tag?.capitalized
                $0.value = 1
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }

    }

    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToParkingSpaceDetailTableViewController", sender: self)
    }
}

