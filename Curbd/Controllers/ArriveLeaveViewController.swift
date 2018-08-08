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

        arriveDatePicker.minimumDate = arriveDate
        leaveDatePicker.minimumDate = Date(timeInterval: 300, since: arriveDate)
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
