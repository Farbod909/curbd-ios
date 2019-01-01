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
import SimpleImageViewer

class ParkingSpaceDrawerViewController: UIViewController {

    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var grabberTapArea: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    //    @IBOutlet weak var noFeaturesLabel: UILabel!
//    @IBOutlet weak var slideshow: ImageSlideshow!
//    @IBOutlet weak var noImagesLabel: UILabel!

//    @IBOutlet weak var testScrollView: UIScrollView!
//    @IBOutlet weak var testStackView: UIStackView!

    var parkingSpace: ParkingSpace?
    var arriveDate: Date?
    var leaveDate: Date?
    var price: Int?

    let partialRevealHeight: CGFloat = 100
    var collapsedHeight: CGFloat = 350
    let drawerPositions: [PulleyPosition] = [
//        .open,
        .partiallyRevealed,
        .collapsed,
    ]

    func initializeSettings() {
//        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
//        slideshow.activityIndicator = DefaultActivityIndicator()
//        let slideshowTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(slideshowClick))
//        slideshow.addGestureRecognizer(slideshowTapRecognizer)

        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self

        let grabberTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(grabberClick))
        grabberTapArea.addGestureRecognizer(grabberTapRecognizer)
    }

    func initializeAppearanceSettings() {
        if let pulleyViewController = parent as? PulleyViewController {
            pulleyViewController.backgroundDimmingOpacity = 0
        }
        featuresScrollView.showsHorizontalScrollIndicator = false

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true

        reserveButton.layer.cornerRadius = 10
        reserveButton.backgroundColor = UIColor.curbdPurpleGradient(frame: reserveButton.frame)
        reserveButton.layer.shadowColor = UIColor.black.cgColor
        reserveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        reserveButton.layer.shadowOpacity = 0.35
        reserveButton.layer.shadowRadius = 4

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        if let parkingSpace = parkingSpace {

            nameLabel.text = parkingSpace.name
            if let arriveDate = arriveDate, let leaveDate = leaveDate {
                subtitleLabel.text = "\(arriveDate.toHumanReadable()) → \(leaveDate.toHumanReadable())"
            }
            if let price = price {
                reserveButton.setTitle("Reserve for \(price.toUSDRepresentation())", for: .normal)
            }

            if parkingSpace.features.isEmpty {
                featuresScrollView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                collapsedHeight -= 65
            }

            if parkingSpace.images.isEmpty {
                imagesCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                collapsedHeight -= 92
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

//                let featureImageView = UIImageView(image: featureImage.imageWithInsets(insets: UIEdgeInsetsMake(2, 2, 2, 2)))
//
//                featureImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//                featureImageView.contentMode = .scaleAspectFit

//                let featureImageView = UIImageView(image: featureImage.imageWithInsets(insets: UIEdgeInsetsMake(0, 0, 0, 0)))
//                featureImageView.contentMode = .scaleAspectFit
//                featureImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                featureImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

                let featureView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
//                featureView.backgroundColor = UIColor.lightGray
                featureView.widthAnchor.constraint(equalToConstant: 65).isActive = true
                featureView.heightAnchor.constraint(equalToConstant: 65).isActive = true

                let featureImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 45, height: 45))
                featureImageView.tintColor = UIColor.magenta
                featureImageView.image = featureImage.imageWithInsets(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
                featureImageView.image = featureImageView.image!.withRenderingMode(.alwaysTemplate)
                featureImageView.tintColor = UIColor.curbdDarkGray
                featureImageView.contentMode = .scaleAspectFit
                featureView.addSubview(featureImageView)
//                featureImageView.backgroundColor = UIColor.yellow
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

//            var parkingSpaceImageSources = [KingfisherSource]()
//
//            if parkingSpace.images.isEmpty {
//                noImagesLabel.isHidden = false
//            }
//
//            for imageUrl in parkingSpace.images {
//                parkingSpaceImageSources.append(KingfisherSource(urlString: imageUrl)!)
//            }
//
//            slideshow.setImageInputs(parkingSpaceImageSources)

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeAppearanceSettings()

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
                pulleyViewController.children[0] as? MapViewController {
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
                        reservationConfirmationViewController.price = price

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

//    @objc func slideshowClick() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//    }

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
            imagesCollectionView.isHidden = true
            reserveButton.isHidden = true
            drawer.backgroundDimmingOpacity = 0
        } else if drawer.drawerPosition == .open {
            featuresScrollView.isHidden = false
            imagesCollectionView.isHidden = false
            reserveButton.isHidden = false
            drawer.backgroundDimmingOpacity = 0.4
        } else if drawer.drawerPosition == .collapsed {
            featuresScrollView.isHidden = false
            imagesCollectionView.isHidden = false
            reserveButton.isHidden = false
            drawer.backgroundDimmingOpacity = 0
        }
    }

}

extension ParkingSpaceDrawerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkingSpace?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "parkingSpaceImagesCollectionViewCell", for: indexPath) as! ParkingSpaceImagesCollectionViewCell
        if let parkingSpace = parkingSpace {
            cell.imageView.kf.setImage(with: URL(string: parkingSpace.images[indexPath.row]))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ParkingSpaceImagesCollectionViewCell

        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imageView
        }

        present(ImageViewerController(configuration: configuration), animated: true)
    }

}
