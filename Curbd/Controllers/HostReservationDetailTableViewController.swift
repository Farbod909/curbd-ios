//
//  HostReservationDetailTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/18/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class HostReservationDetailTableViewController: UITableViewController {

    var reservation: Reservation?
    // Determines if the reservation a current one or a previous one
    var isCurrent: Bool?
    var customerContactPhone: String?

    @IBOutlet weak var customerFullNameLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var parkingSpaceDetailCell: UITableViewCell!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var arriveCell: UITableViewCell!
    @IBOutlet weak var leaveCell: UITableViewCell!
//    @IBOutlet weak var customerContactCell: UITableViewCell!

    func initializeAppearanceSettings() {
        parkingSpaceDetailCell.selectionStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeAppearanceSettings()

        if let reservation = reservation {

            customerFullNameLabel.text = reservation.reserver.fullName

            let vehicle = reservation.vehicle
            vehicleLabel.text = "\(vehicle.make) \(vehicle.model) \(vehicle.licensePlate)"

            parkingSpaceNameLabel.text = reservation.parkingSpace.name

            let parkingSpaceLocation = CLLocation(
                latitude: reservation.parkingSpace.latitude,
                longitude: reservation.parkingSpace.longitude)
            mapView.centerOn(location: parkingSpaceLocation)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(
                reservation.parkingSpace.latitude,
                reservation.parkingSpace.longitude)
            mapView.addAnnotation(annotation)

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                if error == nil {
                    if  let city = placemarks?[0].locality,
                        let state = placemarks?[0].administrativeArea {
                        self.parkingSpaceCityAndStateLabel.text = "\(city), \(state)"
                    }
                }
            }

            priceLabel.text = "+\(reservation.hostIncome.toUSDRepresentation())"

            arriveCell.detailTextLabel?.text = reservation.start.toHumanReadable()
            leaveCell.detailTextLabel?.text = reservation.end.toHumanReadable()

//            customerContactCell.detailTextLabel?.text = String.format(phoneNumber: reservation.reserver.phoneNumber)
//            customerContactPhone = reservation.reserver.phoneNumber

        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
//            if indexPath.row == 1 {
//                if let customerContactPhone = customerContactPhone {
//                    guard let number = URL(string: "tel://" + customerContactPhone) else { return }
//                    UIApplication.shared.open(number, options: [:]) { _ in
//                        tableView.deselectRow(at: indexPath, animated: true)
//                    }
//                }
//            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHostReportTableViewController" {
            let reportTableViewController = segue.destination as! ReportTableViewController
            reportTableViewController.reservation = reservation
            reportTableViewController.hostIsReporting = true
        }
    }



}
