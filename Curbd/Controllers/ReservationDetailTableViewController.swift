//
//  ReservationDetailTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 5/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit
import ImageSlideshow

class ReservationDetailTableViewController: UITableViewController, LoadingViewProtocol {

    var reservation: Reservation?
    // Determines if the reservation a current one or a previous one
    var isCurrent: Bool?
    var hostContactPhone: String?
    var loadingView = LoadingView()

    @IBOutlet weak var parkingSpaceDetailCell: UITableViewCell!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var arriveCell: UITableViewCell!
    @IBOutlet weak var leaveCell: UITableViewCell!
    @IBOutlet weak var instructionsLabel: UILabel!
//    @IBOutlet weak var hostContactCell: UITableViewCell!
    @IBOutlet weak var slideshowCell: UITableViewCell!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    func initializeAppearanceSettings() {
        parkingSpaceDetailCell.selectionStyle = .none

        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        let slideshowTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowClick))
        slideshow.addGestureRecognizer(slideshowTapRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        if let reservation = reservation {

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

            for feature in reservation.parkingSpace.features {

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

                let featureImageView = UIImageView(image: featureImage.imageWithInsets(insets: UIEdgeInsetsMake(2, 2, 2, 2)))

                featureImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.contentMode = .scaleAspectFit

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
            if reservation.cancelled {
                priceLabel.text = "Cancelled"
                priceLabel.textColor = UIColor.systemRed
                priceLabel.adjustsFontSizeToFitWidth = true
            } else {
                priceLabel.text = reservation.cost.toUSDRepresentation()
            }
            paymentMethodLabel.text = reservation.paymentMethodInfo
            arriveCell.detailTextLabel?.text = reservation.start.toHumanReadable()
            leaveCell.detailTextLabel?.text = reservation.end.toHumanReadable()
            instructionsLabel.text = reservation.parkingSpace.instructions

//            if let isCurrent = isCurrent {
//                if !isCurrent {
//                    hostContactCell.isHidden = true
//                }
//            }
//            hostContactCell.detailTextLabel?.text = String.format(phoneNumber: reservation.host.phoneNumber)
//            hostContactPhone = reservation.host.phoneNumber

            var parkingSpaceImageSources = [KingfisherSource]()

            if reservation.parkingSpace.images.isEmpty {
                noImagesLabel.isHidden = false
                slideshowCell.isUserInteractionEnabled = false
            }

            for imageUrl in reservation.parkingSpace.images {
                parkingSpaceImageSources.append(KingfisherSource(urlString: imageUrl)!)
            }

            slideshow.setImageInputs(parkingSpaceImageSources)

        }
    }

    @objc func slideshowClick() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let isCurrent = isCurrent {
            if isCurrent {
                return 2
            }
        }
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
//            if indexPath.row == 5 {
//                if let hostContactPhone = hostContactPhone {
//                    guard let number = URL(string: "tel://" + hostContactPhone) else { return }
//                    UIApplication.shared.open(number, options: [:]) { _ in
//                        tableView.deselectRow(at: indexPath, animated: true)
//                    }
//                }
//            }
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                // "Cancel Reservation" was clicked
                presentConfirmationAlert(title: "Are You Sure?", message: "Are you sure you would like to cancel this reservation?") { alert in
                    if let token = UserDefaults.standard.string(forKey: "token") {
                        self.startLoading()
                        self.reservation?.cancel(withToken: token) { error in
                            self.stopLoading()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportTableViewController" {
            let reportTableViewController = segue.destination as! ReportTableViewController
            reportTableViewController.reservation = reservation
            reportTableViewController.hostIsReporting = false
        } else if segue.identifier == "showReservationExtensionViewController" {
            let reservationExtensionViewController = segue.destination as! ReservationExtensionViewController
            reservationExtensionViewController.reservation = reservation
        }
    }

    @IBAction func unwindToReservationDetailTableViewController(segue:UIStoryboardSegue) { }

    func startLoading() {
        view.addSubview(loadingView)
        loadingView.start()
    }

    func stopLoading() {
        loadingView.removeFromSuperview()
        loadingView.stop()
    }
}
