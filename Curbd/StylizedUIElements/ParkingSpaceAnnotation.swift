//
//  ParkingSpaceWithAnnotation.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/13/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import MapKit

class ParkingSpaceAnnotation: NSObject, MKAnnotation {
    var parkingSpace: ParkingSpace
    var price: Int // not hourly price; rather, full price for duration
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: parkingSpace.latitude, longitude: parkingSpace.longitude)
    }
    var title: String? {
        if parkingSpace.is_third_party {
            return ""
        } else {
            return price.toUSDRepresentation()
        }
    }

    init(_ parkingSpaceWithPrice: ParkingSpaceWithPrice) {
        self.parkingSpace = parkingSpaceWithPrice.parkingSpace
        self.price = parkingSpaceWithPrice.price
    }
}

@available(iOS 11.0, *)
class ParkingSpaceMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet(newAnnotation) {
            if let parkingSpaceAnnotation = newAnnotation as? ParkingSpaceAnnotation {
                if parkingSpaceAnnotation.parkingSpace.is_third_party {
                    markerTintColor = UIColor(hex: "#f09311")
                } else {
                    markerTintColor = UIColor(hex: "#D60E88")

                }
            } else {
                markerTintColor = UIColor(hex: "#D60E88")
            }
            glyphText = "P"
            displayPriority = .required
        }
    }
}

