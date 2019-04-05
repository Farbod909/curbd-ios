//
//  MapViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 9/12/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Pulley
import NVActivityIndicatorView
import SwiftySound

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var currentLocationButton: OnMapButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuButtonImageView: UIImageView!
    @IBOutlet weak var currentVehicleButton: UIButton!
    @IBOutlet weak var currentVehicleButtonImageView: UIImageView!
    @IBOutlet weak var currentVehicleButtonLabel: UILabel!
    @IBOutlet weak var redoSearchButtonSpacingFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButtonSpacingFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentVehicleButtonSpacingFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicatorView: OnMapView!
    var searchLoadingActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: defaultLoadingStyle, color: .gray, padding: nil)

    private let locationManager: CLLocationManager = LocationManager.shared
    var currentlyDisplayedParkingSpaces = [ParkingSpaceAnnotation]()
    var isNextRegionChangeFromUserInteraction = false

    func initializeSettings() {
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

        if #available(iOS 11.0, *) {
            mapView.register(
                ParkingSpaceMarkerAnnotationView.self,
                forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
    }

    func initializeAppearanceSettings() {
        // set redo search button alpha to 0 so we can fade it in later
        redoSearchButton.alpha = 0
        loadingIndicatorView.alpha = 0

        // this is so that when we hide -or do anything else to- the
        // current vehicle button, it also gets applied to the button's
        // label and image view.
        currentVehicleButton.addSubview(currentVehicleButtonLabel)
        currentVehicleButton.addSubview(currentVehicleButtonImageView)

        currentVehicleButtonImageView.image = currentVehicleButtonImageView.image!.withRenderingMode(.alwaysTemplate)
        currentVehicleButtonImageView.tintColor = UIColor.curbdDarkGray

        menuButtonImageView.image = menuButtonImageView.image!.withRenderingMode(.alwaysTemplate)
        menuButtonImageView.tintColor = UIColor.curbdDarkGray


        currentVehicleButton.isHidden = true
        currentLocationButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        mapView.showsCompass = false

        if #available(iOS 11.0, *) {
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14).isActive = true
            currentVehicleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14).isActive = true
            redoSearchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 214).isActive = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()

        locationManager.requestLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make sure vehicle button is updated every time
        // the view re appears.
        updateCurrentVehicleButton()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showSearchDrawerViewController),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
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
        Sound.play(file: "success.wav")
        self.presentSuccessfulReservationPopup()
    }

    @IBAction func unwindToMapViewController(segue:UIStoryboardSegue) {
        updateCurrentVehicleButton()
        performSearchInCurrentlyVisibleArea()
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
     This function is called when the currentLocationButton is clicked.
     It then requests the user's current location and by doing
     so triggers the map to center on the user location and
     update parking space annotations.
     */
    @IBAction func currentLocationButtonClick(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    /**
     This function is called when the user menu button is clicked.
     If a user is logged in, this function shows the user menu; if not,
     the authentication required page is shown to the user instead.
     */
    @IBAction func menuButtonClick(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "token") != nil {
            // if token exists (aka user is logged in)
            instantiateAndShowViewController(withIdentifier: "userMenuVC")
        } else {
            instantiateAndShowViewController(withIdentifier: "authenticationRequiredVC")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVehicleListFromMap" {
            if let vehicleListTableViewController =
                segue.destination as? VehicleListTableViewController {
                vehicleListTableViewController.presentedViaUserMenu = false
            }
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

    @objc func showSearchDrawerViewController() {
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
        if !mapView.selectedAnnotations.isEmpty {
            mapView.deselectAnnotation(
                mapView.selectedAnnotations[0],
                animated: true)
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
            parent?.children[1] as? SearchDrawerViewController {
            locateParkingSpacesOnCurrentMapArea(
                from: searchDrawerViewController.arriveDate,
                to: searchDrawerViewController.leaveDate,
                alertIfNotFound: true,
                selectFirstResult: false)
        } else {

            // make sure redo search button works when the visible drawer
            // is the parking space drawer instead of search drawer.
            if let pulleyViewController = parent as? ParkingPulleyViewController {
                if let searchDrawerViewController = pulleyViewController.savedSearchDrawerViewController {
                    locateParkingSpacesOnCurrentMapArea(
                        from: searchDrawerViewController.arriveDate,
                        to: searchDrawerViewController.leaveDate,
                        alertIfNotFound: true,
                        selectFirstResult: false)
                }
            }
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

        startMapLoadingAnimation()
        ParkingSpace.search(
            bl_lat: bottomLeftCoordinate.latitude,
            bl_long: bottomLeftCoordinate.longitude,
            tr_lat: topRightCoordinate.latitude,
            tr_long: topRightCoordinate.longitude,
            from: startDate,
            to: endDate) { parkingSpacesWithPrice in

                if let parkingSpacesWithPrice = parkingSpacesWithPrice {
                    self.redoSearchButton.fadeOut(0.1) { _ in
                        self.stopMapLoadingAnimation()
                    }

                    if alertIfNotFound && parkingSpacesWithPrice.isEmpty {
                        self.presentNote(text: "It looks like there aren't any parking spots available here during this time.")
                    }

                    let retrievedParkingSpaceAnnotations = parkingSpacesWithPrice.map { ParkingSpaceAnnotation($0) }

                    var optionalMapViewAnnotations = self.mapView.annotations.map() { $0 as? ParkingSpaceAnnotation }
                    optionalMapViewAnnotations = optionalMapViewAnnotations.filter() { $0 != nil }
                    let mapViewAnnotations = optionalMapViewAnnotations.map() { $0! }

                    for parkingSpaceAnnotation in mapViewAnnotations {
                        self.mapView.removeAnnotation(parkingSpaceAnnotation)

//                        if !retrievedParkingSpaceAnnotations.map({ $0.parkingSpace.id }).contains(parkingSpaceAnnotation.parkingSpace.id) {
//                            self.mapView.removeAnnotation(parkingSpaceAnnotation)
//                        }
                    }

                    for parkingSpaceAnnotation in retrievedParkingSpaceAnnotations {
                        self.mapView.addAnnotation(parkingSpaceAnnotation)

//                        if !mapViewAnnotations.map({ ($0.parkingSpace.id) }).contains(parkingSpaceAnnotation.parkingSpace.id) {
//                            self.mapView.addAnnotation(parkingSpaceAnnotation)
//                        }
                    }

                    if selectFirstResult {
                        // if there is at least one parking space found,
                        // automatically select the first one.
//                        if let firstAnnotation = self.currentlyDisplayedParkingSpaces.first {
                        if let firstAnnotation = self.mapView.annotations.first {
                            self.mapView.selectAnnotation(firstAnnotation, animated: false)
                        }
                    }
                } else {
                    // http request failed. Let it fail silently. shhhh...
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
        mapView.centerSlightlyBelow(location: locations.last!)
        // TODO: test when user does not give location
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
//            for parkingSpaceAnnotation in currentlyDisplayedParkingSpaces {
//                if parkingSpaceAnnotation.isEqual(view.annotation) {
//                    parkingSpaceDrawerViewController.parkingSpace =
//                        parkingSpaceAnnotation.parkingSpace
//                    parkingSpaceDrawerViewController.price = parkingSpaceAnnotation.price
//                }
//            }

            if let parkingSpaceAnnotation = view.annotation as? ParkingSpaceAnnotation {
                parkingSpaceDrawerViewController.parkingSpace = parkingSpaceAnnotation.parkingSpace
                parkingSpaceDrawerViewController.price = parkingSpaceAnnotation.price
            }

            if let searchDrawerViewController =
                pulleyViewController.children[1] as? SearchDrawerViewController {

                parkingSpaceDrawerViewController.arriveDate = searchDrawerViewController.arriveDate
                parkingSpaceDrawerViewController.leaveDate = searchDrawerViewController.leaveDate

                // save current searchDrawerVC state for later retrieval
                pulleyViewController.savedSearchDrawerViewController = searchDrawerViewController
            }

            pulleyViewController.setDrawerContentViewController(
                controller: parkingSpaceDrawerViewController,
                animated: false)

            // reposition map such that annotation isn't covered by parking space drawer
            let topOfParkingSpaceDrawer = UIScreen.main.bounds.height - parkingSpaceDrawerViewController.collapsedDrawerHeight(bottomSafeArea: 0)
            if view.center.y > (topOfParkingSpaceDrawer - 50) || view.center.y < 160 {
                let heightDifference = view.center.y - (topOfParkingSpaceDrawer / 2 + 50) // 50 pixels below the center
                mapView.moveCenterByOffSet(offSet: CGPoint(x: 0, y: heightDifference), coordinate: mapView.centerCoordinate)

            }
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

        showSearchDrawerViewController()
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

                if let pulleyViewController = parent as? ParkingPulleyViewController {
                    pulleyViewController.setDrawerPosition(position: .partiallyRevealed, animated: true)
                }

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

    func startMapLoadingAnimation() {
        let buttonHeight = loadingIndicatorView.bounds.size.height
        let buttonWidth = loadingIndicatorView.bounds.size.width
        searchLoadingActivityIndicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        loadingIndicatorView.addSubview(searchLoadingActivityIndicator)
        searchLoadingActivityIndicator.startAnimating()
        loadingIndicatorView.fadeIn(0.1)
    }

    func stopMapLoadingAnimation() {
        loadingIndicatorView.fadeOut(0.1) { _ in
            self.searchLoadingActivityIndicator.removeFromSuperview()
            self.searchLoadingActivityIndicator.stopAnimating()
        }
    }

}
