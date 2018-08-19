//
//  ParkingSpaceDrawerViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/13/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Pulley
import UIKit
import ImageSlideshow

class ParkingSpaceDrawerViewController: UIViewController {

    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var grabberTapArea: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var noImagesLabel: UILabel!

    var parkingSpace: ParkingSpace?
    var arriveDate: Date?
    var leaveDate: Date?
    var pricing: Int?

    let partialRevealHeight: CGFloat = 100
    let collapsedHeight: CGFloat = 240
    let drawerPositions: [PulleyPosition] = [
        .open,
        .partiallyRevealed,
        .collapsed,
    ]

    func initializeAppearanceSettings() {
        reserveButton.layer.cornerRadius = 10
        featuresScrollView.showsHorizontalScrollIndicator = false

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true

        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        let slideshowTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowClick))
        slideshow.addGestureRecognizer(slideshowTapRecognizer)

        let grabberTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(grabberClick))
        grabberTapArea.addGestureRecognizer(grabberTapRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        if let parkingSpace = parkingSpace {

            nameLabel.text = parkingSpace.name

            if  let arriveDate = arriveDate,
                let leaveDate = leaveDate {

                parkingSpace.getPricing(from: arriveDate, to: leaveDate) { pricing in
                    self.pricing = pricing
                    if let pricing = pricing {
                        self.pricingLabel.text = "\(pricing.toUSDRepresentation()) / hr + processing fee"

                        let reservationTimeMinutes = Int(leaveDate.timeIntervalSince(arriveDate) / 60)
//                        let finalCost = (reservationTimeMinutes / 60.0) * pricePerHour
//                        let formattedFinalCost = String(format: "%.02f", finalCost)
                        let price = PaymentClient.calculateCustomerPrice(pricing: pricing, minutes: Int(reservationTimeMinutes))
                        self.reserveButton.setTitle("Reserve for \(price.toUSDRepresentation())", for: .normal)
                    }
                }

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

                let featureImageView = UIImageView(image: featureImage.imageWithInsets(insets: UIEdgeInsetsMake(2, 2, 2, 2)))

                featureImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                featureImageView.contentMode = .scaleAspectFit

                featuresStackView.addArrangedSubview(featureImageView)
            }

            var parkingSpaceImageSources = [KingfisherSource]()

            if parkingSpace.images.isEmpty {
                noImagesLabel.isHidden = false
            }

            for imageUrl in parkingSpace.images {
                parkingSpaceImageSources.append(KingfisherSource(urlString: imageUrl)!)
            }

            slideshow.setImageInputs(parkingSpaceImageSources)

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.setDrawerPosition(position: .collapsed, animated: true)
        }
    }

    /**
     This function is called when the 'X' in the top right corner of the
     parking space detail view is called. It closes the parking space detail
     view and shows the search drawer view instead (with it's previous state
     restored)
    */
    @IBAction func closeButtonClick(_ sender: Any) {
        if let pulleyViewController = parent as? ParkingPulleyViewController {
            pulleyViewController.setDrawerContentViewController(
                controller: pulleyViewController.savedSearchDrawerViewController!,
                animated: false)
            if let mapViewController =
                pulleyViewController.childViewControllers[0] as? MapViewController {
                mapViewController.mapView.deselectAnnotation(
                    mapViewController.mapView.selectedAnnotations[0],
                    animated: true)
                mapViewController.redoSearchButton.isHidden = false
            }
        }
    }

    @IBAction func reserveButtonClick(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            if UserDefaults.standard.string(forKey: "vehicle_license_plate") != nil {
                if  let parkingSpace = parkingSpace,
                    let arriveDate = arriveDate,
                    let leaveDate = leaveDate {

                    if let reservationConfirmationViewController = UIStoryboard(
                        name: "Main",
                        bundle: nil).instantiateViewController(
                            withIdentifier: "reservationConfirmationViewController") as?
                            ReservationConfirmationViewController {
                        reservationConfirmationViewController.modalPresentationStyle =
                            .overCurrentContext
                        reservationConfirmationViewController.parkingSpace = parkingSpace
                        reservationConfirmationViewController.arriveDate = arriveDate
                        reservationConfirmationViewController.leaveDate = leaveDate
                        reservationConfirmationViewController.pricing = pricing

                        show(reservationConfirmationViewController, sender: self)
                    }

                }
            } else {
                presentSingleButtonAlert(
                    title: "No Vehicle Selected",
                    message: "Please add a vehicle first.")
            }
        } else {
            instantiateAndShowViewController(withIdentifier: "authenticationRequiredVC")
        }
    }

    @objc func slideshowClick() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    @objc func grabberClick() {
        if let pulleyViewController = parent as? PulleyViewController {
            if pulleyViewController.drawerPosition == .open {
                pulleyViewController.setDrawerPosition(position: .collapsed, animated: true)
            } else {
                pulleyViewController.setDrawerPosition(position: .open, animated: true)
            }
        }
    }
}

extension ParkingSpaceDrawerViewController: PulleyDrawerViewControllerDelegate {

    func supportedDrawerPositions() -> [PulleyPosition] {
        return drawerPositions
    }

    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return collapsedHeight + bottomSafeArea
    }

    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return partialRevealHeight + bottomSafeArea
    }

    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition == .partiallyRevealed {
            featuresScrollView.isHidden = true
            slideshow.isHidden = true
        } else if drawer.drawerPosition == .open {
            featuresScrollView.isHidden = false
            slideshow.isHidden = false
        } else if drawer.drawerPosition == .collapsed {
            featuresScrollView.isHidden = false
            slideshow.isHidden = true
        }
    }

}
