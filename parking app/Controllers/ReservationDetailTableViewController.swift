//
//  ReservationDetailTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 5/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class ReservationDetailTableViewController: UITableViewController {

    var reservation: Reservation?
    // Determines if the reservation a current one or a previous one
    var isCurrent: Bool?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var arriveCell: UITableViewCell!
    @IBOutlet weak var leaveCell: UITableViewCell!

    func initializeAppearanceSettings() {
        featuresScrollView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let reservation = reservation {

            parkingSpaceNameLabel.text = reservation.parkingSpace.address

            let parkingSpaceLocation = CLLocation(
                latitude: reservation.parkingSpace.latitude,
                longitude: reservation.parkingSpace.longitude)
            mapView.centerOn(location: parkingSpaceLocation)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(
                reservation.parkingSpace.latitude,
                reservation.parkingSpace.longitude)
            mapView.addAnnotation(annotation)

            for feature in reservation.parkingSpace.features {

                let featureImageView = UIImageView()
                featureImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.contentMode = .scaleAspectFit
                switch feature {
                case "Illuminated":
                    featureImageView.image = #imageLiteral(resourceName: "illuminated")
                case "Covered":
                    featureImageView.image = #imageLiteral(resourceName: "covered")
                case "Surveillance":
                    featureImageView.image = #imageLiteral(resourceName: "surveillance")
                case "Guarded":
                    featureImageView.image = #imageLiteral(resourceName: "guarded")
                case "EV Charging":
                    featureImageView.image = #imageLiteral(resourceName: "ev charging")
                default:
                    featureImageView.image = #imageLiteral(resourceName: "question mark")
                }

                featuresStackView.addArrangedSubview(featureImageView)
            }

            let vehicle = reservation.vehicle
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                if error == nil {
                    if  let city = placemarks?[0].locality,
                        let state = placemarks?[0].administrativeArea {
                        self.parkingSpaceCityAndStateLabel.text = "\(city), \(state)"
                    }
                }
            }
            vehicleLabel.text = "\(vehicle.make) \(vehicle.model) \(vehicle.licensePlate)"
            priceLabel.text = "$\(reservation.price) @ $\(reservation.pricePerHour) / hr"
            arriveCell.detailTextLabel?.text = reservation.start.toHumanReadable()
            leaveCell.detailTextLabel?.text = reservation.end.toHumanReadable()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let isCurrent = isCurrent {
            if isCurrent {
                return 2
            }
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                // "Cancel Reservation" was clicked
                if let token = UserDefaults.standard.string(forKey: "token") {
                    reservation?.cancel(withToken: token) { error in
                        
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportTableViewController" {
            let reportTableViewController = segue.destination as! ReportTableViewController
            reportTableViewController.reservation = reservation
        } else if segue.identifier == "showReservationExtensionViewController" {
            let reservationExtensionViewController = segue.destination as! ReservationExtensionViewController
            reservationExtensionViewController.reservation = reservation
        }
    }
}
