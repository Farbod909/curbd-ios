//
//  ReservationListTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReservationListTableViewController: UITableViewController {
    
    var currentReservations = [Reservation]()
    var previousReservations = [Reservation]()

    func initializeSettings() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func initializeAppearanceSettings() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = UserDefaults.standard.string(forKey: "token") {
            User.getCurrentReservations(withToken: token) { error, reservations in
                if let reservations = reservations {
                    self.currentReservations = reservations
                    self.tableView.reloadData()
                }
            }
            User.getPreviousReservations(withToken: token) { error, reservations in
                if let reservations = reservations {
                    self.previousReservations = reservations
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current"
        } else {
            return "Previous"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentReservations.count
        } else {
            return previousReservations.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "reservationCell") as! ReservationTableViewCell
        let reservation: Reservation
        if indexPath.section == 0 {
            reservation = currentReservations[indexPath.row]
        } else {
            reservation = previousReservations[indexPath.row]
        }
        cell.addressLabel.text = reservation.parkingSpace.address
        cell.priceLabel.text = "$\(reservation.price)"
        cell.licensePlateLabel.text = reservation.vehicle.licensePlate
        cell.timePeriodLabel.text
            = "\(reservation.start.toHumanReadable()) - \(reservation.end.toHumanReadable())"

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReservationDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let reservationDetailTableViewController =
                    segue.destination as? ReservationDetailTableViewController {
                    reservationDetailTableViewController.reservation = currentReservations[selectedRow]
                }
            }
        }
    }
    
}
