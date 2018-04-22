//
//  Extensions.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/14/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import MapKit
import UIKit

extension UIViewController {

    func instantiateAndShowViewController(withIdentifier identifier: String) {
        let viewController = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(withIdentifier: identifier)

        show(viewController, sender: self)
    }

    func instantiateAndShowTransparentViewController(withIdentifier identifier: String) {
        let viewController = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(withIdentifier: identifier)
        viewController.modalPresentationStyle = .overCurrentContext

        show(viewController, sender: self)
    }


    func presentSingleButtonAlert(title: String,
                                  message: String,
                                  buttonText: String = "OK",
                                  completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: buttonText,
            style: UIAlertActionStyle.default,
            handler: completion))
        self.present(alert, animated: true, completion: nil)
    }

}

extension Date {

    public func toHumanReadable() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM d"

        return dateFormatter.string(from: self)
    }

    public func round(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .toNearestOrAwayFromZero)
    }

    public func ceil(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .up)
    }

    public func floor(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .down)
    }

    private func round(precision: TimeInterval, rule: FloatingPointRoundingRule) -> Date {
        let seconds = (timeIntervalSinceReferenceDate / precision).rounded(rule) *  precision
        return Date(timeIntervalSinceReferenceDate: seconds)
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

    func centerSlightlyBelow(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300
        let newCoordinate = CLLocationCoordinate2DMake(
            location.coordinate.latitude - 0.0012, // offset to account for drawer
            location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            newCoordinate,
            regionRadius * 2, regionRadius * 2)
        self.setRegion(coordinateRegion, animated: false)
    }

    func centerOn(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300
        let newCoordinate = CLLocationCoordinate2DMake(
            location.coordinate.latitude,
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

    static func getCoordinateFromMapRectanglePoint(x: Double,
                                                   y: Double) -> CLLocationCoordinate2D {
        let swMapPoint: MKMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(swMapPoint)
    }

}

extension UIView {

    func fadeIn(_ duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { self.alpha = 1.0 },
            completion: completion)
    }

    func fadeOut(_ duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { self.alpha = 0.0 },
            completion: completion)
    }
}

extension UIColor {

    convenience init(hex hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }

}
