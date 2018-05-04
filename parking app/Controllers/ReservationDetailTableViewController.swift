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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceAddressLabel: UILabel!
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
                        self.parkingSpaceAddressLabel.text =
                            reservation.parkingSpace.address + ", \(city), \(state)"
                    }
                }
            }
            vehicleLabel.text = "\(vehicle.make) \(vehicle.model) \(vehicle.licensePlate)"
            priceLabel.text = "$\(reservation.price) @ $\(reservation.pricePerHour) / hr"
            arriveCell.detailTextLabel?.text = reservation.start.toHumanReadable()
            leaveCell.detailTextLabel?.text = reservation.end.toHumanReadable()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
}
