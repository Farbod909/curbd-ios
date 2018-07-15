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
    var repeatingAvailabilities = [RepeatingAvailability]()
    var fixedAvailabilities = [FixedAvailability]()

    var isPreview = false

    override func viewDidLoad() {

        if isPreview {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Publish", style: .done, target: self, action: #selector(publishListing(_:)))
            navigationItem.title = "Preview"
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let parkingSpace = parkingSpace {
            if let token = UserDefaults.standard.string(forKey: "token") {
                parkingSpace.getRepeatingAvailabilities(withToken: token) { error, repeatingAvailabilities in
                    if let repeatingAvailabilities = repeatingAvailabilities {
                        self.repeatingAvailabilities = repeatingAvailabilities
                        self.tableView.reloadData()
                    }
                }
                parkingSpace.getFixedAvailabilities(withToken: token) { error, fixedAvailabilities in
                    if let fixedAvailabilities = fixedAvailabilities {
                        self.fixedAvailabilities = fixedAvailabilities
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return repeatingAvailabilities.count + fixedAvailabilities.count
        } else if section == 2 {
            if isPreview {
                return 1
            } else {
                return 3
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isPreview {
            if section == 1 {
                return "Availabilities"
            }
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if isPreview {
            if section == 1 {
                return "Specify the dates and times during which you would like your space to be available"
            }
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // parking space detail cell
                
                let parkingSpaceDetailCell = tableView.dequeueReusableCell(
                    withIdentifier: "parkingSpaceDetailCell") as! ParkingSpaceDetailTableViewCell

                if let parkingSpace = parkingSpace {

                    parkingSpaceDetailCell.parkingSpaceNameLabel.text = parkingSpace.address

                    let parkingSpaceLocation = CLLocation(
                        latitude: parkingSpace.latitude,
                        longitude: parkingSpace.longitude)
                    parkingSpaceDetailCell.mapView.centerOn(location: parkingSpaceLocation)

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(
                        parkingSpace.latitude,
                        parkingSpace.longitude)
                    parkingSpaceDetailCell.mapView.addAnnotation(annotation)


                    for subview in parkingSpaceDetailCell.featuresStackView.subviews {
                        parkingSpaceDetailCell.featuresStackView.removeArrangedSubview(subview)
                    }

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
                        parkingSpaceDetailCell.featuresStackView.addArrangedSubview(
                            featureImageView)
                    }

                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                        if error == nil {
                            if  let city = placemarks?[0].locality,
                                let state = placemarks?[0].administrativeArea {
                                parkingSpaceDetailCell.parkingSpaceCityAndStateLabel.text = "\(city), \(state)"
                            }
                        }
                    }

                    if parkingSpace.available_spaces > 1 {
                        parkingSpaceDetailCell.numberOfSpotsLabel.text = "\(parkingSpace.available_spaces) SPOTS"
                    } else {
                        parkingSpaceDetailCell.numberOfSpotsLabel.text = "\(parkingSpace.available_spaces) SPOT"
                    }

                }
                return parkingSpaceDetailCell
            }
        } else if indexPath.section == 1 {

            if indexPath.row < repeatingAvailabilities.count {
                let repeatingAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "repeatingAvailabilityCell") as! RepeatingAvailabilityTableViewCell
                let repeatingAvailability = repeatingAvailabilities[indexPath.row]
                repeatingAvailabilityCell.repeatingDaysLabel.text = repeatingAvailability.repeating_days.joined(separator: ", ")
                repeatingAvailabilityCell.timeRangeLabel.text =
                "\(repeatingAvailability.start_time.timeComponentString()) - \(repeatingAvailability.end_time.timeComponentString())"

                return repeatingAvailabilityCell
            } else {
                let fixedAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "fixedAvailabilityCell") as! FixedAvailabilityTableViewCell
                let fixedAvailability = fixedAvailabilities[indexPath.row - repeatingAvailabilities.count]
                fixedAvailabilityCell.startDateTimeLabel.text = "From: " + fixedAvailability.start_datetime.toHumanReadable()
                fixedAvailabilityCell.endDateTimeLabel.text = "Until: " + fixedAvailability.end_datetime.toHumanReadable()

                return fixedAvailabilityCell
            }

        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // add availability
                let addAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "actionCell")

                addAvailabilityCell?.textLabel?.text = "Add Availability"

                return addAvailabilityCell!

            } else if indexPath.row == 1 {
                // reservation history
                let reservationHistoryCell = tableView.dequeueReusableCell(
                    withIdentifier: "actionCell")

                reservationHistoryCell?.textLabel?.text = "Reservation History"

                return reservationHistoryCell!

            } else if indexPath.row == 2 {
                // delete listing
                let deleteListingCell = tableView.dequeueReusableCell(
                    withIdentifier: "dangerousActionCell")

                deleteListingCell?.textLabel?.text = "Delete Listing"

                return deleteListingCell!

            }
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                instantiateAndShowViewController(withIdentifier: "addAvailabilityViewController")
            } else if indexPath.row == 1 {
                let reservationHistoryTableViewController = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(withIdentifier: "reservationHistoryTableViewController") as! ReservationListTableViewController
                reservationHistoryTableViewController.parkingSpace = parkingSpace
                show(reservationHistoryTableViewController, sender: self)
            } else if indexPath.row == 2 {
                // TODO: delete listing
            }
        }
    }

    @IBAction func unwindToParkingSpaceDetailTableViewController(segue:UIStoryboardSegue) { }

    @objc func publishListing(_ sender: UIBarButtonItem) {
        print("==================")
        print("hellloooooooooo")
        print("==================")
    }
}

