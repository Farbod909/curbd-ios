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

    // flag to determine whether this page will be used to
    // list reservation history for a parking space listing
    // or if it will be used to list reservations for a
    // customer
    var isListingReservations = false

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

        if navigationController?.viewControllers.count == 1 {
            // root view controller
            // This means that this view was opened 'modally' (sort of).
            // In other words, it was opened from the user menu.
            isListingReservations = false
        }

        if isListingReservations {
            // delete custom left bar button item so that the
            // default back button appears instead.
            navigationItem.leftBarButtonItem = nil

            if let token = UserDefaults.standard.string(forKey: "token") {
                // get reservations for a parking space
            }
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClick(_:)))

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
    }

    @objc func cancelButtonClick(_ sender: UIBarButtonItem) {
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
        cell.vehicleLabel.text = "\(reservation.vehicle.make) \(reservation.vehicle.model) \(reservation.vehicle.licensePlate)"
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
                    if indexPath.section == 0 {
                        reservationDetailTableViewController.isCurrent = true
                        reservationDetailTableViewController.reservation =
                            currentReservations[selectedRow]
                    } else if indexPath.section == 1 {
                        reservationDetailTableViewController.isCurrent = false
                        reservationDetailTableViewController.reservation =
                            previousReservations[selectedRow]
                    }
                }
            }
        }
    }
    
}
