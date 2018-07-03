//
//  ParkingSpaceDetailTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class ParkingSpaceDetailTableViewController: UITableViewController {

    var parkingSpace: ParkingSpace?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var numberOfSpotsLabel: UILabel!

    func initializeAppearanceSettings() {
        featuresScrollView.showsHorizontalScrollIndicator = false
    }

    override func viewDidLoad() {
        initializeAppearanceSettings()

        if let parkingSpace = parkingSpace {

            parkingSpaceNameLabel.text = parkingSpace.address

            let parkingSpaceLocation = CLLocation(
                latitude: parkingSpace.latitude,
                longitude: parkingSpace.longitude)
            mapView.centerOn(location: parkingSpaceLocation)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(
                parkingSpace.latitude,
                parkingSpace.longitude)
            mapView.addAnnotation(annotation)

            for feature in parkingSpace.features {

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

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                if error == nil {
                    if  let city = placemarks?[0].locality,
                        let state = placemarks?[0].administrativeArea {
                        self.parkingSpaceCityAndStateLabel.text = "\(city), \(state)"
                    }
                }
            }

        }
        
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
                // delete listing
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListingReservationHistory" {
            let reservationListTableViewController = segue.destination as! ReservationListTableViewController

            reservationListTableViewController.isListingReservations = true
        }
    }
}

