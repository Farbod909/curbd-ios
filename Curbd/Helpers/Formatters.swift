//
//  Formatters.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/24/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Eureka

/**
 Taken from https://gist.github.com/moshegutman/5e91f6b892f5ac1e4fbedc86c95e58f9
 */
class UppercaseFormatter : Formatter {

    override func string(for obj: Any?) -> String? {
        if let stringValue = obj as? String {
            return stringValue.uppercased()
        }
        return nil
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject
        return true
    }
}

/**
 Taken from Eureka example application.
 Link: https://github.com/xmartlabs/Eureka/blob/master/Example/Example/Controllers/FormatterExample.swift
 */
class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
            // Check if the currency symbol is at the last index
            if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                str = String(str[..<str.index(before: str.endIndex)])

            }
        }
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }

    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
    }
}
