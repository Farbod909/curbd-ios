//
//  ParkingSpaceDrawerViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/13/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Pulley
import UIKit

class ParkingSpaceDrawerViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        if let parkingSpace = parkingSpace {

            addressLabel.text = parkingSpace.address

            if  let arriveDate = arriveDate,
                let leaveDate = leaveDate {

                parkingSpace.getPricing(from: arriveDate, to: leaveDate) { pricing in
                    self.pricing = pricing
                    if let pricing = pricing {
                        let pricePerHour = Double(pricing * 12)/100.0
                        let formattedPricePerHour = String(format: "%.02f", pricePerHour)
                        self.pricingLabel.text = "$\(formattedPricePerHour) / hr"
                    }
                }

            }

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
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.setDrawerPosition(position: .collapsed)
        }
    }

    /**
     This function is called when the 'X' in the top right corner of the
     parking space detail view is called. It closes the parking space detail
     view and shows the search drawer view instead (with it's previous state
     restored)
    */
    @IBAction func dismissButtonClick(_ sender: Any) {
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
}

extension ParkingSpaceDrawerViewController: PulleyDrawerViewControllerDelegate {

    func collapsedDrawerHeight() -> CGFloat {
        if iphoneX {
            return collapsedHeight + 26
        }
        return collapsedHeight
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if iphoneX {
            return partialRevealHeight + 26
        }
        return partialRevealHeight
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .partiallyRevealed {
            featuresScrollView.isHidden = true
        } else if drawer.drawerPosition == .open {
            featuresScrollView.isHidden = false
        } else if drawer.drawerPosition == .collapsed {
            featuresScrollView.isHidden = false
        }
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return drawerPositions
    }
}
