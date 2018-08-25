//
//  ArriveLeaveViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 11/18/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class ArriveLeaveViewController: LightTranslucentViewController {

    @IBOutlet weak var arriveDatePicker: UIDatePicker!
    @IBOutlet weak var leaveDatePicker: UIDatePicker!

    var arriveDate = Date()
    var leaveDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        arriveDatePicker.setDate(arriveDate, animated: false)
        leaveDatePicker.setDate(leaveDate, animated: false)

        arriveDatePicker.minimumDate = Date().ceil(precision: 300)
        leaveDatePicker.minimumDate = Date(timeInterval: 7200, since: Date()).ceil(precision: 300)

        arriveDatePicker.addTarget(self, action: #selector(arriveDatePickerValueChanged), for: .valueChanged)
    }

    @objc func arriveDatePickerValueChanged(datePicker: UIDatePicker) {
        leaveDatePicker.minimumDate = Date(timeInterval: 7200, since: datePicker.date)
    }
    
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    /**
     This button essentially behaves as a "save" button.
     The unwind view controller is responsible for performing
     the actual search.
     */
    @IBAction func searchButtonClick(_ sender: UIButton) {
        arriveDate = arriveDatePicker.date
        leaveDate = leaveDatePicker.date
        performSegue(withIdentifier: "unwindToSearchDrawer", sender: self)
    }
}
