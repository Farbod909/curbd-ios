//
//  ReservationExtensionViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReservationExtensionViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!

    var reservation: Reservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let reservation = reservation {
            datePicker.setDate(reservation.end, animated: false)
            datePicker.minimumDate = reservation.end
        }
    }

    @IBAction func submitButtonClick(_ sender: UIBarButtonItem) {
        // TODO: request extension
    }
}
