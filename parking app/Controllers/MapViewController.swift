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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        locationManager.requestLocation()
    }

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300

        var newCoordinate = CLLocationCoordinate2D()
        newCoordinate.latitude = location.coordinate.latitude - 0.0015
        newCoordinate.longitude = location.coordinate.longitude

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newCoordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }

    func getNECoordinate() -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMaxX(self.mapView.visibleMapRect),
            y: self.mapView.visibleMapRect.origin.y)
    }

    func getNWCoordinate() -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMinX(self.mapView.visibleMapRect),
            y: self.mapView.visibleMapRect.origin.y)
    }

    func getSECoordinate() -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMaxX(self.mapView.visibleMapRect),
            y: MKMapRectGetMaxY(self.mapView.visibleMapRect))
    }

    func getSWCoordinate() -> CLLocationCoordinate2D {
        return getCoordinateFromMapRectanglePoint(
            x: self.mapView.visibleMapRect.origin.x,
            y: MKMapRectGetMaxY(self.mapView.visibleMapRect))
    }

    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        let swMapPoint: MKMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(swMapPoint)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnLocation(location: locations[0])
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

