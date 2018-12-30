//
//  Extensions.swift
//  Curbd
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

    func presentSingleButtonAlert(title: String,
                                  message: String,
                                  buttonText: String = "OK",
                                  completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: buttonText,
            style: UIAlertAction.Style.default,
            handler: completion))
        self.present(alert, animated: true, completion: nil)
    }

    func presentConfirmationAlert(title: String,
                                  message: String,
                                  completion: ((UIAlertAction) -> Void)?) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func presentValidationErrorAlert(from error: ValidationError,
                                     completion: ((UIAlertAction) -> Void)? = nil) {
        var message = ""
        for (key, value) in error.fields {
            message += "\(key.replacingOccurrences(of: "_", with: " ")): \(value)\n".firstLetterCapitalized()
        }
        self.presentSingleButtonAlert(
            title: "Invalid Fields",
            message: message.trim())

    }

    func presentServerErrorAlert(completion: ((UIAlertAction) -> Void)? = nil) {
        presentSingleButtonAlert(
            title: "Server Error",
            message: "Oops, something went wrong. Try again later!",
            completion: completion)
    }

    func startLoading(_ loadingView: LoadingView, disabledButton: UIBarButtonItem? = nil) {
        view.addSubview(loadingView)
        loadingView.start()

        if let button = disabledButton {
            button.isEnabled = false
        }
    }

    func stopLoading(_ loadingView: LoadingView, disabledButton: UIBarButtonItem? = nil) {
        loadingView.removeFromSuperview()
        loadingView.stop()

        if let button = disabledButton {
            button.isEnabled = true
        }
    }

}

extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func firstLetterCapitalized() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    static func random(length: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }


    // taken from https://stackoverflow.com/questions/32364055/formattting-phone-number-in-swift
    static func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")

        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }

        let hasAreaCode = (length >= 10)
        var sourceIndex = 0

        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }

        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }

        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength

        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }

        return leadingOne + areaCode + prefix + "-" + suffix
    }

    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }

        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }

        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension Date {

    public func dateComponentAsParseableString() -> String {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)

        return "\(month)-\(day)-\(year)"
    }

    public func toHumanReadable() -> String {
        let dateFormatter = DateFormatter()

        let calendar = NSCalendar.current
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: self) + ", Today"
        } else if calendar.isDateInTomorrow(self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: self) + ", Tomorrow"
        } else {
            dateFormatter.dateFormat = "h:mm a, MMM d"
            return dateFormatter.string(from: self)
        }
    }

    public func toHumanReadableWithYear() -> String {
        let dateFormatter = DateFormatter()

        let calendar = NSCalendar.current
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: self) + ", Today"
        } else if calendar.isDateInTomorrow(self) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: self) + ", Tomorrow"
        } else {
            dateFormatter.dateFormat = "h:mm a, MMM d, YYYY"
            return dateFormatter.string(from: self)
        }
    }

    public func timeComponentString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }

    public func timeComponentStringIso8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:00"
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

    func centerSlightlyBelow(location: CLLocation, animated: Bool = false) {
        let regionRadius: CLLocationDistance = 300
        let newCoordinate = CLLocationCoordinate2DMake(
            location.coordinate.latitude - 0.0012, // offset to account for drawer
            location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion.init(
            center: newCoordinate,
            latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        self.setRegion(coordinateRegion, animated: animated)
    }

    func centerOn(location: CLLocation, regionRadius: CLLocationDistance = 300, animated: Bool = false) {
        let newCoordinate = CLLocationCoordinate2DMake(
            location.coordinate.latitude,
            location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion.init(
            center: newCoordinate,
            latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        self.setRegion(coordinateRegion, animated: animated)
    }

    func moveCenterByOffSet(offSet: CGPoint, coordinate: CLLocationCoordinate2D) {
        var point = self.convert(coordinate, toPointTo: self)

        point.x += offSet.x
        point.y += offSet.y

        let center = self.convert(point, toCoordinateFrom: self)
        self.setCenter(center, animated: true)
    }

    func getNECoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: self.visibleMapRect.maxX,
            y: self.visibleMapRect.origin.y)
    }

    func getNWCoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: self.visibleMapRect.minX,
            y: self.visibleMapRect.origin.y)
    }

    func getSECoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: self.visibleMapRect.maxX,
            y: self.visibleMapRect.maxY)
    }

    func getSWCoordinate() -> CLLocationCoordinate2D {
        return MKMapView.getCoordinateFromMapRectanglePoint(
            x: self.visibleMapRect.origin.x,
            y: self.visibleMapRect.maxY)
    }

    static func getCoordinateFromMapRectanglePoint(x: Double,
                                                   y: Double) -> CLLocationCoordinate2D {
        let swMapPoint: MKMapPoint = MKMapPoint.init(x: x, y: y)
        return swMapPoint.coordinate
    }

}

extension UIView {

    func fadeIn(_ duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 1.0 },
            completion: completion)
    }

    func fadeOut(_ duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 0.0 },
            completion: completion)
    }

    func blink() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: [.curveLinear, .autoreverse],
            animations: {self.alpha = 0.2}) { finished in
                self.alpha = 1
        }
    }

}

extension UIColor {

    static var systemGreen: UIColor {
        return UIColor(hex: "40c427")
    }

    static var systemRed: UIColor {
        return UIColor(hex: "db4d4d")
    }

    static var systemGray: UIColor {
        return UIColor(hex: "555555")
    }

    static var curbdPurpleMiddle: UIColor {
        return UIColor(hex: "8D2688")
    }

    static var curbdPurpleDark: UIColor {
        return UIColor(hex: "4b2f8a")
    }

    static var curbdPurpleBright: UIColor {
        return UIColor(hex: "d60e88")
    }

    static func curbdPurpleGradient(frame: CGRect) -> UIColor {
        return UIColor.colorWithGradient(frame: frame, colors: [curbdPurpleDark, curbdPurpleBright])
    }

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

    static func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {

        // create the background layer that will hold the gradient
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        backgroundGradientLayer.frame = frame

        // we create an array of CG colors from out UIColor array
        let cgColors = colors.map({$0.cgColor})

        backgroundGradientLayer.colors = cgColors

        UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: backgroundColorImage!)
    }

}

extension Int {
    func toUSDRepresentation() -> String {
        let numberFormatter = NumberFormatter()
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: "usd",
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true

        return numberFormatter.string(from: NSNumber(value: Float(self)/100))!
    }
}

/**
 Taken from: https://stackoverflow.com/questions/46437504/adding-padding-and-border-to-an-uiimageview
 */
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
