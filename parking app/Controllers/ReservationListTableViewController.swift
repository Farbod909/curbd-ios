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
            User.getCustomerReservations(withToken: token) { error, reservations in
                if let reservations = reservations {
                    self.reservations = reservations
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "reservationCell") as! ReservationTableViewCell
        let reservation = reservations[indexPath.row]
        cell.addressLabel.text = reservation.parkingSpace.address
        cell.priceLabel.text = "$\(reservation.price)"
        cell.licensePlateLabel.text = reservation.vehicle.licensePlate
        cell.timePeriodLabel.text
            = "\(reservation.start.toHumanReadable()) - \(reservation.end.toHumanReadable())"
        return cell
    }
    
}
