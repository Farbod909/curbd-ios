//
//  AddAvailabilityViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka

class AddRepeatingAvailabilityViewController: FormViewController {

    func initializeSettings() {
        animateScroll = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        form
            +++ Section("Days")
            <<< CheckRow("sunday") {
                $0.title = $0.tag?.capitalized
            }
            <<< CheckRow("monday") {
                $0.title = $0.tag?.capitalized
                $0.value = true
            }
            <<< CheckRow("tuesday") {
                $0.title = $0.tag?.capitalized
                $0.value = true
            }
            <<< CheckRow("wednesday") {
                $0.title = $0.tag?.capitalized
                $0.value = true
            }
            <<< CheckRow("thursday") {
                $0.title = $0.tag?.capitalized
                $0.value = true
            }
            <<< CheckRow("friday") {
                $0.title = $0.tag?.capitalized
                $0.value = true
            }
            <<< CheckRow("saturday") {
                $0.title = $0.tag?.capitalized
            }

            +++ Section("Time Range")
            <<< TimeInlineRow("from"){
                $0.title = $0.tag?.capitalized
                $0.value = Date()
            }
            <<< TimeInlineRow("until"){
                $0.title = $0.tag?.capitalized
                $0.value = Date()
            }

            +++ DecimalRow("price per hour"){
                $0.useFormatterDuringInput = true
                $0.title = $0.tag?.capitalized
                $0.value = 1
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }


    }

    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToAvailabilitiesViewController", sender: self)
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

