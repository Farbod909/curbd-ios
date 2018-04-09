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

    @IBOutlet weak var datePicker: UIDatePicker!

    var lastSavedDateString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:'00'"
        self.lastSavedDateString = dateFormatter.string(from: datePicker.date)
        self.performSegue(withIdentifier: "unwindToDrawer", sender: self)
    }
}
