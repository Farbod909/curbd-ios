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
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var currentVehicleButton: UIButton!
    @IBOutlet weak var currentVehicleButtonImageView: UIImageView!
    @IBOutlet weak var currentVehicleButtonLabel: UILabel!
    @IBOutlet weak var redoSearchButtonSpacingFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountButtonSpacingFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentVehicleButtonSpacingFromTopConstraint: NSLayoutConstraint!

    private let locationManager: CLLocationManager = LocationManager.shared
    var currentlyDisplayedParkingSpaces = [ParkingSpaceWithAnnotation]()
    var isNextRegionChangeFromUserInteraction = false

    func initializeSettings() {
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }

    func initializeAppearanceSettings() {
        // set redo search button alpha to 0 so we can fade it in later
        redoSearchButton.alpha = 0

        // this is so that when we hide -or do anything else to- the
        // current vehicle button, it also gets applied to the button's
        // label and image view.
        currentVehicleButton.addSubview(currentVehicleButtonLabel)
        currentVehicleButton.addSubview(currentVehicleButtonImageView)

        currentVehicleButton.isHidden = true

        if iphoneX {
            redoSearchButtonSpacingFromBottomConstraint.constant += 26
            currentVehicleButtonSpacingFromTopConstraint.constant += 26
            accountButtonSpacingFromTopConstraint.constant += 26
            view.updateConstraints()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()

        locationManager.requestLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        // make sure vehicle button is updated every time
        // the view re appears.
        updateCurrentVehicleButton()
    }

    /**
     This function hides the parking space detail view after confirming
     a reservation and reperforms a search in the currently visible area
     to remove the parking space that was just reserved from the map.
    */
    @IBAction func unwindToMapViewControllerAfterReservationConfirmation(segue:UIStoryboardSegue) {
        if let pulleyViewController = parent as? ParkingPulleyViewController {
            pulleyViewController.setDrawerContentViewController(
                controller: pulleyViewController.savedSearchDrawerViewController!,
                animated: false)
            mapView.deselectAnnotation(
                mapView.selectedAnnotations[0],
                animated: false)
            redoSearchButton.isHidden = false
            performSearchInCurrentlyVisibleArea()
        }
    }

    @IBAction func unwindToMapViewControllerAfterAuthentication(segue:UIStoryboardSegue) {
        updateCurrentVehicleButton()
    }

    /**
     This function is called when the redoSearchButton is clicked.
     It then performs a search for parking spaces in the currently
     visible map area.
    */
    @IBAction func redoSearchButtonClick(_ sender: UIButton) {
        performSearchInCurrentlyVisibleArea()
    }

    /**
     This function is called when the user account button is clicked.
     If a user is logged in, this function shows the user menu; if not,
     the authentication required page is shown to the user instead.
     */
    @IBAction func accountButtonClick(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            // if token exists (aka user is logged in)
            instantiateAndShowTransparentViewController(
                withIdentifier: "userMenuVC")
        } else {
            instantiateAndShowTransparentViewController(
                withIdentifier: "authenticationRequiredVC")
        }
    }

    /**
     Determines if user has a currently selected vehicle and is
     logged in, and based on that information appropriately hides
     or shows the currentVehicleButton and/or alters the button's
     text to reflect any changes.
     */
    func updateCurrentVehicleButton() {
        if let currentVehicleLicensePlate = UserDefaults.standard.string(
            forKey: "vehicle_license_plate") {
            currentVehicleButton.isHidden = false
            currentVehicleButtonLabel.text = currentVehicleLicensePlate
        } else {
            if UserDefaults.standard.string(forKey: "token") != nil {
                // user is logged in
                currentVehicleButton.isHidden = false
                currentVehicleButtonLabel.text = "Add Vehicle"
            } else {
                currentVehicleButton.isHidden = true
            }
        }
    }

    /**
     Performs a search of parking spaces in currently visible map
     area filtered by the dates provided in the search drawer view
     controller, and then annotates them on the map.

     This does not alert the user if no parking spaces were found.

     This does not automatically select the first result.
     */
    func performSearchInCurrentlyVisibleArea() {
        if let searchDrawerViewController =
            parent?.childViewControllers[1] as? SearchDrawerViewController {
            locateParkingSpacesOnCurrentMapArea(
                from: searchDrawerViewController.arriveDate,
                to: searchDrawerViewController.leaveDate,
                alertIfNotFound: false,
                selectFirstResult: false)
        }
    }

    /**
     This function searches for parking spaces that are available in a
     given time frame and that are located in the currently visible map
     area. Afterwards, this function creates and places a `MKPointAnnotation`
     on the map for each found parking space.

     This function also hides `redoSearchButton`.

     - parameter startDate: The `Date` from which the spaces should be available.
     - parameter endDate: The `Date` until which the spaces should be available.
     - parameter alertIfNotFound: Whether or not to alert the user if no
     parking spaces were found.
     - parameter selectFirstResult: Whether or not to automatically select the
     annotation for the first result.
    */
    func locateParkingSpacesOnCurrentMapArea(from startDate: Date,
                                             to endDate: Date,
                                             alertIfNotFound: Bool,
                                             selectFirstResult: Bool) {
        let bottomLeftCoordinate: CLLocationCoordinate2D = mapView.getSWCoordinate()
        let topRightCoordinate: CLLocationCoordinate2D = mapView.getNECoordinate()
        ParkingSpace.search(
            bl_lat: bottomLeftCoordinate.latitude,
            bl_long: bottomLeftCoordinate.longitude,
            tr_lat: topRightCoordinate.latitude,
            tr_long: topRightCoordinate.longitude,
            from: startDate,
            to: endDate) { parkingSpaces in
                if let parkingSpaces = parkingSpaces {
                    if alertIfNotFound && parkingSpaces.isEmpty {
                        // alert user that no parking spaces were found
                        self.presentSingleButtonAlert(
                            title: "No Nearby Parking",
                            message:
                            """
                            It looks like there aren't any parking spots
                            available during this time and location.
                            """)
                    }

                    // TODO: don't remove and re-add to map if a parking
                    // space overlaps between previous search and this one

                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.currentlyDisplayedParkingSpaces = []
                    for parkingSpace in parkingSpaces {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(
                            parkingSpace.latitude,
                            parkingSpace.longitude)

                        annotation.title = parkingSpace.address
                        self.mapView.addAnnotation(annotation)
                        self.currentlyDisplayedParkingSpaces.append(
                            ParkingSpaceWithAnnotation(
                                parkingSpace: parkingSpace, annotation: annotation))
                    }
                    if selectFirstResult {
                        // if there is at least one parking space found,
                        // automatically select the first one.
                        if let firstAnnotation =
                            self.currentlyDisplayedParkingSpaces.first?.annotation {
                            self.mapView.selectAnnotation(firstAnnotation, animated: false)
                        }
                    }
                    self.redoSearchButton.fadeOut(0.1)
                } else {
                    // http request failed
                }
        }
    }

}

extension MapViewController: CLLocationManagerDelegate {

    /**
     This function is called when the user's current location is first
     updated. It then centers the map at that location and performs a
     search for nearby parking spaces.
     */
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        mapView.centerOn(location: locations.last!) // TODO: test when user does not give location
        performSearchInCurrentlyVisibleArea()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }

}

extension MapViewController: MKMapViewDelegate {

    /**
     This function shows a `ParkingSpaceDrawerViewController` with the details
     of the selected parking space.
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // ignore if user selects current location
        if (view.annotation?.isKind(of: MKUserLocation.self))! {
            return
        }

        if let pulleyViewController = parent as? ParkingPulleyViewController {
            // instantiate new view controller to display parking space
            // detail contents as a drawer.
            let parkingSpaceDrawerViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(
                    withIdentifier: "parkingSpaceDrawerVC") as! ParkingSpaceDrawerViewController

            // find parking space associated with selected annotation
            // and send it to the ParkingSpaceDrawerViewController.
            for parkingSpaceWithAnnotation in currentlyDisplayedParkingSpaces {
                if parkingSpaceWithAnnotation.annotation.isEqual(view.annotation) {
                    parkingSpaceDrawerViewController.parkingSpace =
                        parkingSpaceWithAnnotation.parkingSpace
                }
            }

            if let searchDrawerViewController =
                pulleyViewController.childViewControllers[1] as? SearchDrawerViewController {
                // save current searchDrawerVC state for later retrieval
                pulleyViewController.savedSearchDrawerViewController = searchDrawerViewController
            }

            pulleyViewController.setDrawerContentViewController(
                controller: parkingSpaceDrawerViewController,
                animated: false)

            // make sure redo search button is hidden
            // regardless of fadeIn() or fadeOut()
            // function calls
            redoSearchButton.isHidden = true
        }
    }

    /**
     This function hides the `ParkingSpaceDrawerViewController` and shows the
     `SearchDrawerViewController` again. This function also makes sure
     that the `SearchDrawerViewController` is restored with it's old
     content.
     */
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // ignore if user deselects current location
        if (view.annotation?.isKind(of: MKUserLocation.self))! {
            return
        }

        if let pulleyViewController = parent as? ParkingPulleyViewController {
            if let savedSearchDrawerViewController =
                pulleyViewController.savedSearchDrawerViewController {
                // load the saved SearchDrawerViewController
                pulleyViewController.setDrawerContentViewController(
                    controller: savedSearchDrawerViewController,
                    animated: false)
            } else {
                // reload a SearchDrawerViewController from scratch
                let searchDrawerViewController = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(
                        withIdentifier: "searchDrawerVC")
                pulleyViewController.setDrawerContentViewController(
                    controller: searchDrawerViewController,
                    animated: false)
            }
            redoSearchButton.isHidden = false
        }
    }

    /**
     This function determines if the reason for the change of region
     is due to human interaction and sets the value of
     `isNextRegionChangeFromUserInteraction` to true if so.
     */
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let view: UIView? = mapView.subviews.first
        // Look through gesture recognizers to determine
        // whether this region change is from user interaction
        for recognizer in (view?.gestureRecognizers)! {
            if recognizer.state == .began || recognizer.state == .ended {
                isNextRegionChangeFromUserInteraction = true
                break
            }
        }
    }

    /**
     After the region change has completed (i.e. user stops dragging or
     region change animation ends), this function shows `redoSearchButton`
     if the region change was due to human interaction.
    */
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isNextRegionChangeFromUserInteraction {
            isNextRegionChangeFromUserInteraction = false
            redoSearchButton.fadeIn(0.1)
        }
    }

}
