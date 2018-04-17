//
//  ArriveViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 11/18/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class ArriveLeaveViewController: UIViewController {

    @IBOutlet weak var arriveDatePicker: UIDatePicker!
    @IBOutlet weak var leaveDatePicker: UIDatePicker!

    var arriveDate = Date()
    var leaveDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        arriveDatePicker.setDate(arriveDate, animated: false)
        leaveDatePicker.setDate(leaveDate, animated: false)

        // uncomment this after figuring out how to set view
        // background color to clear
//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.frame
//        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonClick(_ sender: UIButton) {
        arriveDate = arriveDatePicker.date
        leaveDate = leaveDatePicker.date
        performSegue(withIdentifier: "unwindToDrawer", sender: self)
    }
}
