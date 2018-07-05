//
//  ReportSubmissionViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReportSubmissionViewController: UIViewController {

    var reportReason: String?
    var reservation: Reservation?
    @IBOutlet weak var commentsTextView: UITextView!

    @IBAction func submitButtonClick(_ sender: UIBarButtonItem) {
        if let reportReason = reportReason {
            // TODO: submit report
        }
    }
    
}
