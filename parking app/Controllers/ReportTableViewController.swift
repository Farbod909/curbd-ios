//
//  ReportTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {

    let reportReasons = [
        "Parking space not available",
        "Can't locate parking address",
        "Parking hazard present",
        "Technical issue",
        "Unresponsive host",
        "Other",
    ]

    var reservation: Reservation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportReasons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "reportReasonCell")!
        cell.textLabel?.text = reportReasons[indexPath.row]
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportSubmissionViewController" {
            if let cell = sender as? UITableViewCell {
                let reportSubmissionViewController = segue.destination as! ReportSubmissionViewController
                reportSubmissionViewController.reservation = reservation
                reportSubmissionViewController.reportReason = cell.textLabel?.text
            }
        }
    }
}
