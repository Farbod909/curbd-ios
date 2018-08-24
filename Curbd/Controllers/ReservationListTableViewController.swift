//
//  ReservationListTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ReservationListTableViewController: UITableViewController {
    
    var parkingSpace: ParkingSpace?
    var isHost = false
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
            if let parkingSpace = parkingSpace {
                parkingSpace.getCurrentReservations(withToken: token) { error, reservations in
                    if let reservations = reservations {
                        self.currentReservations = reservations
                        self.tableView.reloadData()
                    }
                }
                parkingSpace.getPreviousReservations(withToken: token) { error, reservations in
                    if let reservations = reservations {
                        self.previousReservations = reservations
                        self.tableView.reloadData()
                    }
                }
            } else {
                if isHost {
                    User.getHostCurrentReservations(withToken: token) { error, reservations in
                        if let reservations = reservations {
                            self.currentReservations = reservations
                            self.tableView.reloadData()
                        }
                    }
                    User.getHostPreviousReservations(withToken: token) { error, reservations in
                        if let reservations = reservations {
                            self.previousReservations = reservations
                            self.tableView.reloadData()
                        }
                    }
                } else {
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
    }

    @IBAction func dismissButtonClick(_ sender: UIBarButtonItem) {
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
        if parkingSpace != nil {
            cell.titleLabel.text = "\(reservation.reserver.firstName.capitalized) \(reservation.reserver.lastName.prefix(1).capitalized)."

            if reservation.cancelled {
                cell.priceLabel.text = "Cancelled"
                cell.priceLabel.textColor = UIColor.systemRed
                cell.priceLabel.adjustsFontSizeToFitWidth = true
            } else {
                cell.priceLabel.text = "+\(reservation.hostIncome.toUSDRepresentation())"
            }
        } else {
            if isHost {
                cell.titleLabel.text = "\(reservation.reserver.firstName.capitalized) \(reservation.reserver.lastName.prefix(1).capitalized). @ \(reservation.parkingSpace.name)"

                if reservation.cancelled {
                    cell.priceLabel.text = "Cancelled"
                    cell.priceLabel.textColor = UIColor.systemRed
                    cell.priceLabel.adjustsFontSizeToFitWidth = true
                } else {
                    cell.priceLabel.text = "+\(reservation.hostIncome.toUSDRepresentation())"
                }
            } else {
                cell.titleLabel.text = reservation.parkingSpace.name

                if reservation.cancelled {
                    cell.priceLabel.text = "Cancelled"
                    cell.priceLabel.textColor = UIColor.systemRed
                    cell.priceLabel.adjustsFontSizeToFitWidth = true
                } else {
                    cell.priceLabel.text = "+\(reservation.cost.toUSDRepresentation())"
                }
            }
        }
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
        } else if segue.identifier == "showHostReservationDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let reservationDetailTableViewController =
                    segue.destination as? HostReservationDetailTableViewController {
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
