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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    private let locationManager = LocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
//        mapView.delegate = self

        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestLocation()

        logoText.textColor = UIColor.gray.withAlphaComponent(0.8)
        logoView.layer.cornerRadius = 10
        logoView.layer.masksToBounds = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            logoView.backgroundColor = UIColor.clear

            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = logoView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            logoView.addSubview(blurEffectView)
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnLocation(location: locations[0])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }

    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300

        var newCoordinate = CLLocationCoordinate2D()
        newCoordinate.latitude = location.coordinate.latitude - 0.0015
        newCoordinate.longitude = location.coordinate.longitude


        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newCoordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

//extension MapViewController: MKMapViewDelegate {
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
//    {
//        print("hello")
//    }
//}

