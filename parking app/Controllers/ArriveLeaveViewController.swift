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

        self.arriveDatePicker.setDate(self.arriveDate, animated: false)
        self.leaveDatePicker.setDate(self.leaveDate, animated: false)

        // uncomment this after figuring out how to set view
        // background color to clear
//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.frame
//        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:'00'"
//        self.arriveDateString = dateFormatter.string(from: arriveDatePicker.date)
//        self.leaveDateString = dateFormatter.string(from: leaveDatePicker.date)

        self.arriveDate = arriveDatePicker.date
        self.leaveDate = leaveDatePicker.date

        self.performSegue(withIdentifier: "unwindToDrawer", sender: self)
    }
}
