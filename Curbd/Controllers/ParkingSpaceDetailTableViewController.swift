//
//  ParkingSpaceDetailTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit
import ImageSlideshow

class ParkingSpaceDetailTableViewController: UITableViewController {

    var parkingSpace: ParkingSpace?
    var repeatingAvailabilities = [RepeatingAvailability]()
    var fixedAvailabilities = [FixedAvailability]()

    var openedFromHostDashboard = false
    var isPreview = false

    override func viewDidLoad() {

        if isPreview {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonClick(_:)))
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
                parkingSpace.getFutureFixedAvailabilities(withToken: token) { error, fixedAvailabilities in
                    if let fixedAvailabilities = fixedAvailabilities {
                        self.fixedAvailabilities = fixedAvailabilities
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.isMovingFromParent {
            if isPreview {
                if let token = UserDefaults.standard.string(forKey: "token") {
                    parkingSpace?.delete(withToken: token) { error in
                        if error != nil {
                            self.presentServerErrorAlert()
                        }
                    }
                }
            }
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let parkingSpace = parkingSpace, !parkingSpace.images.isEmpty {
                return 3
            }
            return 2
        } else if section == 1 {
            return repeatingAvailabilities.count + fixedAvailabilities.count + 1
        } else if section == 2 {
            if isPreview {
                return 0
            } else {
                return 1
            }
        } else if section == 3 {
            if isPreview {
                return 0
            } else {
                return 2
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
        } else {
            if section == 2 {
                if let parkingSpace = parkingSpace {
                    if parkingSpace.is_active {
                        return "Making your listing inactive will hide it on the map and prevent customers from reserving it as long as it is inactive. You can always make your listing active again."
                    } else {
                        return "Making your listing active will ensure that your parking space is available for customers to reserve. You can later make your listing inactive again."
                    }
                }
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

                // this prevents the row from being highlighted when
                // scrolling through features
                parkingSpaceDetailCell.selectionStyle = .none

                if let parkingSpace = parkingSpace {

                    parkingSpaceDetailCell.nameLabel.text = parkingSpace.name

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
                        subview.removeFromSuperview()
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
                        case "Gated":
                            featureImage = #imageLiteral(resourceName: "gated")
                        default:
                            featureImage = #imageLiteral(resourceName: "question mark")
                        }

                        let featureView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
                        featureView.widthAnchor.constraint(equalToConstant: 65).isActive = true
                        featureView.heightAnchor.constraint(equalToConstant: 65).isActive = true

                        let featureImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 45, height: 45))
                        featureImageView.tintColor = UIColor.magenta
                        featureImageView.image = featureImage.imageWithInsets(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
                        featureImageView.image = featureImageView.image!.withRenderingMode(.alwaysTemplate)
                        featureImageView.tintColor = UIColor.curbdDarkGray
                        featureImageView.contentMode = .scaleAspectFit
                        featureView.addSubview(featureImageView)
                        featureImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
                        featureImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
                        featureImageView.topAnchor.constraint(equalTo: featureView.topAnchor).isActive = true

                        let featureLabel = UILabel(frame: CGRect(x: 0, y: 45, width: 65, height: 20))
                        featureLabel.text = feature
                        featureLabel.textAlignment = .center
                        featureLabel.font = UIFont(name: "Helvetica", size: 11)
                        featureLabel.textColor = UIColor.curbdDarkGray
                        featureView.addSubview(featureLabel)
                        featureLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
                        featureLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                        featureLabel.topAnchor.constraint(equalTo: featureImageView.bottomAnchor).isActive = true
                        featureLabel.bottomAnchor.constraint(equalTo: featureView.bottomAnchor).isActive = true

                        parkingSpaceDetailCell.featuresStackView.addArrangedSubview(featureView)

                    }

                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                        if error == nil {
                            if  let city = placemarks?[0].locality,
                                let state = placemarks?[0].administrativeArea {
                                parkingSpaceDetailCell.cityAndStateLabel.text = "\(city), \(state)"
                            }
                        }
                    }

                    if parkingSpace.available_spaces > 1 {
                        parkingSpaceDetailCell.numberOfSpotsLabel.text = "\(parkingSpace.available_spaces) SPOTS"
                    } else {
                        parkingSpaceDetailCell.numberOfSpotsLabel.text = "\(parkingSpace.available_spaces) SPOT"
                    }

                    parkingSpaceDetailCell.sizeLabel.text =
                        Vehicle.sizeDescriptions[parkingSpace.size]?.uppercased()

                }
                return parkingSpaceDetailCell
            } else if indexPath.row == 1 {
                let parkingSpaceInstructionsCell = tableView.dequeueReusableCell(
                    withIdentifier: "infoCell") as! MultiLineLabelTableViewCell
                if let parkingSpace = parkingSpace {
                    parkingSpaceInstructionsCell.label.text = parkingSpace.instructions
                }
                return parkingSpaceInstructionsCell
            } else if indexPath.row == 2 {
                let slideshowCell = tableView.dequeueReusableCell(
                    withIdentifier: "slideshowCell") as! SlideshowCell
                slideshowCell.selectionStyle = .none

                slideshowCell.slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
                slideshowCell.slideshow.activityIndicator = DefaultActivityIndicator()
//                let slideshowTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowClick))
//                slideshowCell.slideshow.addGestureRecognizer(slideshowTapRecognizer)

                if let parkingSpace = parkingSpace {

                    var parkingSpaceImageSources = [KingfisherSource]()

                    for imageUrl in parkingSpace.images {
                        parkingSpaceImageSources.append(KingfisherSource(urlString: imageUrl)!)
                    }

                    slideshowCell.slideshow.setImageInputs(parkingSpaceImageSources)
                }

//                func slideshowClick() {
//                    let fullScreenController = slideshowCell.slideshow.presentFullScreenController(from: self)
//                    fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//                }
                return slideshowCell
            }
        } else if indexPath.section == 1 {

            if indexPath.row < repeatingAvailabilities.count {
                let repeatingAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "repeatingAvailabilityCell") as! RepeatingAvailabilityTableViewCell
                let repeatingAvailability = repeatingAvailabilities[indexPath.row]

                repeatingAvailabilityCell.repeatingDaysLabel.text = repeatingAvailability.humanReadableDays

                if repeatingAvailability.all_day {
                    repeatingAvailabilityCell.timeRangeLabel.text = "All day"
                } else {
                    repeatingAvailabilityCell.timeRangeLabel.text =
                    "\(repeatingAvailability.start_time!.timeComponentString()) - \(repeatingAvailability.end_time!.timeComponentString())"
                }

                repeatingAvailabilityCell.priceLabel.text = repeatingAvailability.formattedHourlyPrice

                return repeatingAvailabilityCell
            } else if indexPath.row == (repeatingAvailabilities.count + fixedAvailabilities.count) {
                // add availability
                let addAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "actionCell")

                addAvailabilityCell?.textLabel?.text = "Add Availability"

                return addAvailabilityCell!
            } else {
                let fixedAvailabilityCell = tableView.dequeueReusableCell(
                    withIdentifier: "fixedAvailabilityCell") as! FixedAvailabilityTableViewCell
                let fixedAvailability = fixedAvailabilities[indexPath.row - repeatingAvailabilities.count]
                fixedAvailabilityCell.startDateTimeLabel.text = "From: " + fixedAvailability.start_datetime.toHumanReadableWithYear()
                fixedAvailabilityCell.endDateTimeLabel.text = "Until: " + fixedAvailability.end_datetime.toHumanReadableWithYear()
                fixedAvailabilityCell.priceLabel.text = fixedAvailability.formattedHourlyPrice

                return fixedAvailabilityCell
            }

        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // toggle active
                if let parkingSpace = parkingSpace {
                    let toggleActiveCell: UITableViewCell?

                    if parkingSpace.is_active {
                        toggleActiveCell = tableView.dequeueReusableCell(
                            withIdentifier: "dangerousActionCell")
                        toggleActiveCell?.textLabel?.text = "Make Inactive"
                    } else {
                        toggleActiveCell = tableView.dequeueReusableCell(
                            withIdentifier: "actionCell")
                        toggleActiveCell?.textLabel?.text = "Make Active"
                    }

                    return toggleActiveCell!
                }
                return UITableViewCell()
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                // reservation history
                let reservationHistoryCell = tableView.dequeueReusableCell(
                    withIdentifier: "disclosureCell")

                reservationHistoryCell?.textLabel?.text = "Reservation History"

                return reservationHistoryCell!

            } else if indexPath.row == 1 {
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
        if indexPath.section == 1 {
            let availabilityTypeViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(withIdentifier: "availabilityTypeViewController") as! AvailabilityTypeViewController

            availabilityTypeViewController.parkingSpace = parkingSpace
            show(availabilityTypeViewController, sender: self)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                if  let token = UserDefaults.standard.string(forKey: "token"),
                    let parkingSpace = parkingSpace {

                    let parameters: [String : Any] = [
                        "is_active": !parkingSpace.is_active
                    ]
                    parkingSpace.patch(withToken: token, parameters: parameters) { error in
                        if error != nil {
                            self.presentServerErrorAlert()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let reservationHistoryTableViewController = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(withIdentifier: "reservationHistoryTableViewController") as! ReservationListTableViewController
                reservationHistoryTableViewController.parkingSpace = parkingSpace
                show(reservationHistoryTableViewController, sender: self)
            } else if indexPath.row == 1 {
                presentConfirmationAlert(
                    title: "Are You Sure?",
                    message: "Are you sure you would like to delete this parking space?") { action in
                        if let token = UserDefaults.standard.string(forKey: "token") {
                            self.parkingSpace?.delete(withToken: token) { error in
                                if error != nil {
                                    self.presentServerErrorAlert()
                                } else {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presentConfirmationAlert(title: "Are You Sure?", message: "WARNING: All current reservations must be honored. By deleting this availability you are preventing future reservations at these times.") { alert in
                if let _ = tableView.cellForRow(at: indexPath) as? RepeatingAvailabilityTableViewCell {
                    if let token = UserDefaults.standard.string(forKey: "token") {
                        self.repeatingAvailabilities[indexPath.row].delete(withToken: token) { error in
                            if error == nil {
                                self.repeatingAvailabilities.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                            } else {
                                self.presentServerErrorAlert()
                            }
                        }
                    }
                }

                if let _ = tableView.cellForRow(at: indexPath) as? FixedAvailabilityTableViewCell {
                    if let token = UserDefaults.standard.string(forKey: "token") {
                        self.fixedAvailabilities[indexPath.row - self.repeatingAvailabilities.count].delete(withToken: token) { error in
                            if error == nil {
                                self.fixedAvailabilities.remove(at: indexPath.row - self.repeatingAvailabilities.count)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                            } else {
                                self.presentServerErrorAlert()
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func unwindToParkingSpaceDetailTableViewController(segue:UIStoryboardSegue) { }

    @objc func saveButtonClick(_ sender: UIBarButtonItem) {

        if repeatingAvailabilities.isEmpty && fixedAvailabilities.isEmpty {
            presentConfirmationAlert(
                title: "No Availabilities Yet",
                message: "Are you sure you'd like to save without adding availabilities? If not, tap on 'Add Availability'.") { alert in
                    // user confirmed save

                    // present option to save or publish
                    self.showSaveOrPublishActionMenu()

            }
        } else {

            // present option to save or publish
            showSaveOrPublishActionMenu()

        }

    }

    func showSaveOrPublishActionMenu() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let publishAction = UIAlertAction(title: "Publish Now", style: .default) { alert in
            if let token = UserDefaults.standard.string(forKey: "token") {
                self.parkingSpace?.patch(withToken: token, parameters: [
                    "is_active": true
                ]) { error in
                    if error != nil {
                        self.presentServerErrorAlert()
                    } else {
                        // if user is already a host just dismiss back to listings table
                        // else if user is a newly created host, update the user menu to
                        // "Host Dashboard" and show it to them
                        if UserDefaults.standard.bool(forKey: "user_is_host") {
                            if self.openedFromHostDashboard {
                                self.performSegue(withIdentifier: "unwindToHostDashboardAfterAddingListing", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "unwindToParkingSpacesListAfterModifying", sender: self)
                            }
                        } else {
                            self.performSegue(withIdentifier: "unwindToUserMenuViewController", sender: self)
                        }
                    }
                }
            }
        }

        let saveForLaterAction = UIAlertAction(title: "Save For Later", style: .default) { alert in
            // if user is already a host just dismiss back to listings table
            // else if user is a newly created host, update the user menu to
            // "Host Dashboard" and show it to them
            if UserDefaults.standard.bool(forKey: "user_is_host") {
                if self.openedFromHostDashboard {
                    self.performSegue(withIdentifier: "unwindToHostDashboardAfterAddingListing", sender: self)
                } else {
                    self.performSegue(withIdentifier: "unwindToParkingSpacesListAfterModifying", sender: self)
                }
            } else {
                self.performSegue(withIdentifier: "unwindToUserMenuViewController", sender: self)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            // do nothing
        }

        optionMenu.addAction(publishAction)
        optionMenu.addAction(saveForLaterAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true)
    }
}

