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
    var isPreview = false

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var numberOfSpotsLabel: UILabel!
    @IBOutlet weak var reservationHistoryCell: UITableViewCell!
    @IBOutlet weak var deleteListingCell: UITableViewCell!

    func initializeAppearanceSettings() {
        featuresScrollView.showsHorizontalScrollIndicator = false
    }

    override func viewDidLoad() {
        initializeAppearanceSettings()

        if isPreview {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Publish", style: .done, target: self, action: #selector(publishListing(_:)))
            navigationItem.title = "Preview"
            reservationHistoryCell.isHidden = true
            deleteListingCell.isHidden = true
        }

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

                let featureImage: UIImage
                switch feature {
                case "Illuminated":
                    featureImage = #imageLiteral(resourceName: "illuminated")
                case "Covered":
                    featureImage = #imageLiteral(resourceName: "covered")
                case "Surveillance":
                    featureImage = #imageLiteral(resourceName: "surveillance")
                case "Guarded":
                    featureImage = #imageLiteral(resourceName: "guarded")
                case "EV Charging":
                    featureImage = #imageLiteral(resourceName: "ev charging")
                default:
                    featureImage = #imageLiteral(resourceName: "question mark")
                }

                let featureImageView = UIImageView(image: featureImage.imageWithInsets(insets: UIEdgeInsetsMake(2, 2, 2, 2)))

                featureImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.contentMode = .scaleAspectFit

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
                // TODO: delete listing
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListingAvailabilities" {
            let availabilitiesTableViewController = segue.destination as! AvailabilitiesTableViewController
            availabilitiesTableViewController.parkingSpace = parkingSpace
        }
    }

    @objc func publishListing(_ sender: UIBarButtonItem) {
        print("==================")
        print("hellloooooooooo")
        print("==================")
    }
}

