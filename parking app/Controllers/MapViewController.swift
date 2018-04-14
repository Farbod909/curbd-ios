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

    func locateParkingSpacesOnCurrentMapArea(from start: Date, to end: Date, alertIfNotFound: Bool) {
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
            self.mapView.removeAnnotations(self.mapView.annotations)
            for parkingSpace in parkingSpaces {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(
                    parkingSpace.latitude,
                    parkingSpace.longitude)

                annotation.title = parkingSpace.address
                self.mapView.addAnnotation(annotation)
            }
            // if there is at least one parking space found,
            // automatically select the first one.
            // NOTE: annotations[0] is current location
            if self.mapView.annotations.indices.contains(1) {
                self.mapView.selectAnnotation(self.mapView.annotations[1], animated: false)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.centerOn(location: locations.last!)
        let drawerVC = self.parent?.childViewControllers[1] as! DrawerViewController
        self.locateParkingSpacesOnCurrentMapArea(
            from: drawerVC.arriveDate,
            to: drawerVC.leaveDate,
            alertIfNotFound: false)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pulleyVC = self.parent as? PulleyViewController
        {
            let drawerContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parkingSpaceVC")

            pulleyVC.setDrawerContentViewController(controller: drawerContent, animated: false)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let pulleyVC = self.parent as? PulleyViewController
        {
            let drawerContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "drawerVC")

            pulleyVC.setDrawerContentViewController(controller: drawerContent, animated: false)
        }
    }
}
