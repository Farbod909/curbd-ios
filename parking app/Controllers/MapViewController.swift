//
//  MapViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 9/12/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Pulley

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var redoSearchButtonSpacingFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountButton: UIButton!

    private let locationManager = LocationManager.shared
    var currentlyDisplayParkingSpaces = [ParkingSpaceWithAnnotation]()
    var isNextRegionChangeIsFromUserInteraction = false

    func initializeSettings() {
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }

    func initializeAppearanceSettings() {
        self.redoSearchButton.alpha = 0 // initially it is hidden

        if iphoneX {
            self.redoSearchButtonSpacingFromBottomConstraint.constant -= 26
            self.view.updateConstraints()
        }

        self.accountButton.layer.cornerRadius = 15
        self.accountButton.layer.shadowColor = UIColor.black.cgColor
        self.accountButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.accountButton.layer.shadowOpacity = 0.25
        self.accountButton.layer.shadowRadius = 3

        self.redoSearchButton.backgroundColor = UIColor.white
        self.redoSearchButton.layer.cornerRadius = 15
        self.redoSearchButton.layer.shadowColor = UIColor.black.cgColor
        self.redoSearchButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.redoSearchButton.layer.shadowOpacity = 0.25
        self.redoSearchButton.layer.shadowRadius = 3

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()

        locationManager.requestLocation()
    }

    @IBAction func redoSearchButtonClick(_ sender: UIButton) {
        let searchDrawerVC = self.parent?.childViewControllers[1] as! SearchDrawerViewController
        self.locateParkingSpacesOnCurrentMapArea(from: searchDrawerVC.arriveDate, to: searchDrawerVC.leaveDate, alertIfNotFound: false, selectFirstResult: false)
    }

    @IBAction func accountButtonClick(_ sender: UIButton) {
        if let _ = UserDefaults.standard.string(forKey: "token") {
            let userMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userMenuVC")

            self.present(userMenuVC, animated: true)
        } else {
            let authenticationRequiredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authenticationRequiredVC")

            self.present(authenticationRequiredVC, animated: true)
        }
    }
    func locateParkingSpacesOnCurrentMapArea(from start: Date, to end: Date, alertIfNotFound: Bool, selectFirstResult: Bool) {
        let bottomLeft: CLLocationCoordinate2D = mapView.getSWCoordinate()
        let topRight: CLLocationCoordinate2D = mapView.getNECoordinate()
        ParkingSpace.search(
            bl_lat: bottomLeft.latitude,
            bl_long: bottomLeft.longitude,
            tr_lat: topRight.latitude,
            tr_long: topRight.longitude,
            from: start,
            to: end
        ) { parkingSpaces in
            if alertIfNotFound && parkingSpaces.isEmpty {
                // alert user that no parking spaces were found
                let alert = UIAlertController(title: "No Nearby Parking", message: "It looks like there aren't any parking spots available during this time and location.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            // TODO: don't remove and re-add to map if a parking
            // space overlaps between previous search and this one

            self.mapView.removeAnnotations(self.mapView.annotations)
            self.currentlyDisplayParkingSpaces = []
            for parkingSpace in parkingSpaces {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(
                    parkingSpace.latitude,
                    parkingSpace.longitude)

                annotation.title = parkingSpace.address
                self.mapView.addAnnotation(annotation)
                self.currentlyDisplayParkingSpaces.append(
                    ParkingSpaceWithAnnotation(parkingSpace: parkingSpace, annotation: annotation))
            }
            if selectFirstResult {
                // if there is at least one parking space found,
                // automatically select the first one.
                if let firstAnnotation = self.currentlyDisplayParkingSpaces.first?.annotation {
                    self.mapView.selectAnnotation(firstAnnotation, animated: false)
                }
            }
            self.redoSearchButton.fadeOut(0.1)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.centerOn(location: locations.last!)
        let searchDrawerVC = self.parent?.childViewControllers[1] as! SearchDrawerViewController
        self.locateParkingSpacesOnCurrentMapArea(
            from: searchDrawerVC.arriveDate,
            to: searchDrawerVC.leaveDate,
            alertIfNotFound: false,
            selectFirstResult: false)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // ignore if user selects current location
        if (view.annotation?.isKind(of: MKUserLocation.self))! { return }

        if let pulleyVC = self.parent as? ParkingPulleyViewController {
            let parkingSpaceDrawerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkingSpaceDrawerVC") as! ParkingSpaceDrawerViewController

            // find parking space associated with selected annotation
            // and send it to ParkingSpaceViewController.
            for parkingSpaceWithAnnotation in currentlyDisplayParkingSpaces {
                if parkingSpaceWithAnnotation.annotation.isEqual(view.annotation) {
                    parkingSpaceDrawerVC.parkingSpace = parkingSpaceWithAnnotation.parkingSpace
                }
            }
            let searchDrawerVC = pulleyVC.childViewControllers[1] as! SearchDrawerViewController
            pulleyVC.savedSearchDrawerVC = searchDrawerVC // save current searchDrawerVC state for later retrieval
            pulleyVC.setDrawerContentViewController(controller: parkingSpaceDrawerVC, animated: false)

            // make sure redo search button is hidden
            // regardless of fadeIn() or fadeOut()
            // function calls
            self.redoSearchButton.isHidden = true
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // ignore if user deselects current location
        if (view.annotation?.isKind(of: MKUserLocation.self))! { return }

        if let pulleyVC = self.parent as? ParkingPulleyViewController {
            pulleyVC.setDrawerContentViewController(controller: pulleyVC.savedSearchDrawerVC!, animated: false)
            self.redoSearchButton.isHidden = false
        }
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let view: UIView? = mapView.subviews.first
        // Look through gesture recognizers to determine
        // whether this region change is from user interaction
        for recognizer in (view?.gestureRecognizers)! {
            if recognizer.state == .began || recognizer.state == .ended {
                self.isNextRegionChangeIsFromUserInteraction = true
                break
            }
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if self.isNextRegionChangeIsFromUserInteraction {
            self.isNextRegionChangeIsFromUserInteraction = false
            self.redoSearchButton.fadeIn(0.1)
        }
    }
}
