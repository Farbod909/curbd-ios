//
//  ReportSubmissionViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReportSubmissionViewController: UIViewController {

    var reportReason: String?
    var reservation: Reservation?
    // a boolean flag to determine whether a host
    // or a customer is reporting a reservation.
    var hostIsReporting: Bool?

    @IBOutlet weak var commentsTextView: UITextView!

    @IBAction func submitButtonClick(_ sender: UIBarButtonItem) {
        if let reportReason = reportReason, let reservation = reservation, let hostIsReporting = hostIsReporting {
            if let token = UserDefaults.standard.string(forKey: "token") {
                reservation.report(
                    withToken: token,
                    title: reportReason,
                    comments: commentsTextView.text,
                    hostIsReporting: hostIsReporting) { error in
                        if error != nil {
                            self.presentServerErrorAlert()
                        } else {
                            self.presentSingleButtonAlert(title: "Success", message: "We'll get back to you as soon as possible.", buttonText: "OK") { _ in
                                if hostIsReporting {
                                    self.performSegue(
                                        withIdentifier: "unwindToHostReservationDetailTableViewController",
                                        sender: self)
                                } else {
                                    self.performSegue(
                                        withIdentifier: "unwindToReservationDetailTableViewController",
                                        sender: self)
                                }
                            }
                        }
                }
            }
        }
    }
    
}
