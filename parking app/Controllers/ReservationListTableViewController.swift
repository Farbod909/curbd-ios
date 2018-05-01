//
//  ReservationListTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReservationListTableViewController: UITableViewController {
    
    var reservations = [Reservation]()

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return reservations.count
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "reservationCell") as! ReservationTableViewCell
//        let reservation = reservations[indexPath.row]
        return cell
    }
    
}
