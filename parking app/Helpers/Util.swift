//
//  File.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import MapKit

let baseURL = "http://192.168.0.104:8000"

extension Date {
    func toHumanReadable() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM d"

        return dateFormatter.string(from: self)
    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,]
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}

extension MKMapView {
    func centerOn(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300
        let newCoordinate = CLLocationCoordinate2DMake(
            location.coordinate.latitude - 0.0012, // offset to account for drawer
            location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            newCoordinate,
            regionRadius * 2, regionRadius * 2)
        self.setRegion(coordinateRegion, animated: false)
    }

    func getNECoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMaxX(self.visibleMapRect),
            y: self.visibleMapRect.origin.y)
    }

    func getNWCoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMinX(self.visibleMapRect),
            y: self.visibleMapRect.origin.y)
    }

    func getSECoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: MKMapRectGetMaxX(self.visibleMapRect),
            y: MKMapRectGetMaxY(self.visibleMapRect))
    }

    func getSWCoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: self.visibleMapRect.origin.x,
            y: MKMapRectGetMaxY(self.visibleMapRect))
    }

    static func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        let swMapPoint: MKMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(swMapPoint)
    }
}
