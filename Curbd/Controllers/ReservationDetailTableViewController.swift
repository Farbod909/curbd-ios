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
import Contacts

class ReservationDetailTableViewController: UITableViewController {

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
    @IBOutlet weak var directionsChevronImageView: UIImageView!

    func initializeAppearanceSettings() {
        parkingSpaceDetailCell.selectionStyle = .none

        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        let slideshowTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowClick))
        slideshow.addGestureRecognizer(slideshowTapRecognizer)

        directionsChevronImageView.image = directionsChevronImageView.image!.withRenderingMode(.alwaysTemplate)
        directionsChevronImageView.tintColor = UIColor.curbdPurpleBright
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

            if reservation.parkingSpace.features.isEmpty {
                featuresScrollView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }

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

                featuresStackView.addArrangedSubview(featureView)

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
                slideshow.heightAnchor.constraint(equalToConstant: 0).isActive = true
                slideshowCell.isHidden = true
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

    @IBAction func mapIconClick(_ sender: UIButton) {

        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let openInAppleMapsOption = UIAlertAction(title: "Apple Maps", style: .default) { alert in
            if let reservation = self.reservation {
                let coordinate = CLLocationCoordinate2D(
                    latitude: reservation.parkingSpace.latitude,
                    longitude: reservation.parkingSpace.longitude)
                let placemark = MKPlacemark(coordinate: coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = reservation.parkingSpace.name
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            }
        }

        let openInGoogleMapsOption = UIAlertAction(title: "Google Maps", style: .default) { alert in
            if let reservation = self.reservation {
                guard let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(reservation.parkingSpace.latitude),\(reservation.parkingSpace.longitude)&directionsmode=driving") else {
                    return
                }

                if UIApplication.shared.canOpenURL(googleMapsURL) {
                    UIApplication.shared.open(googleMapsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            // do nothing
        }

        optionMenu.addAction(openInAppleMapsOption)
        optionMenu.addAction(openInGoogleMapsOption)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true)

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
                        self.startLoading(self.loadingView)
                        self.reservation?.cancel(withToken: token) { error in
                            self.stopLoading(self.loadingView)
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

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
