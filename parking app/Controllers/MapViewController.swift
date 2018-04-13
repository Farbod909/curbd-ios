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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private let locationManager = LocationManager.shared

    func initializeSettings() {
        mapView.delegate = self
        mapView.showsUserLocation = true

        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        locationManager.requestLocation()
    }

    func annotateMap(with parkingSpaces: [ParkingSpace]) {
        for parkingSpace in parkingSpaces {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(
                parkingSpace.latitude,
                parkingSpace.longitude)

            annotation.title = parkingSpace.address
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        mapView.centerOn(location: locations.last!)

        let drawerVC = self.parent?.childViewControllers[1] as! DrawerViewController

        let bottomLeft: CLLocationCoordinate2D = mapView.getSWCoordinate()
        let topRight: CLLocationCoordinate2D = mapView.getNECoordinate()

        ParkingSpace.search(
            bl_lat: bottomLeft.latitude,
            bl_long: bottomLeft.longitude,
            tr_lat: topRight.latitude,
            tr_long: topRight.longitude,
            from: drawerVC.arriveDate,
            to: drawerVC.leaveDate
        ) { parkingSpaces in
            self.annotateMap(with: parkingSpaces)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("hello")
    }
}

