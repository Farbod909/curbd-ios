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

    var parkingSpace: ParkingSpace?

    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weekdaysFull = ["Sunday", "Monday", "Tuesday",
                        "Wednesday", "Thursday", "Friday", "Saturday"]

    func initializeSettings() {
        animateScroll = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        for (index, weekday) in weekdays.enumerated() {

            form
                +++ (index == 0 ? Section("select weekdays") : Section())
                <<< CheckRow(weekday) {
                    $0.title = weekdaysFull[index]
                    $0.value = false
                }
                <<< TimeInlineRow("\(weekday) start"){
                    $0.title = "From"
                    $0.value = Date()
                    $0.hidden = Condition(stringLiteral: "$\(weekday) == false")
                }
                <<< TimeInlineRow("\(weekday) end"){
                    $0.title = "Until"
                    $0.value = Date()
                    $0.hidden = Condition(stringLiteral: "$\(weekday) == false")
                }
                <<< DecimalRow("\(weekday) pricing"){
                    $0.useFormatterDuringInput = true
                    $0.title = "Price Per Hour"
                    $0.value = 1
                    let formatter = CurrencyFormatter()
                    formatter.locale = .current
                    formatter.numberStyle = .currency
                    $0.formatter = formatter
                    $0.hidden = Condition(stringLiteral: "$\(weekday) == false")
                }
        }

    }

    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {

        var daysWithRange = [String: RepeatingAvailabilityTimeRange]()

        for weekday in weekdays {
            if let checked = (form.rowBy(tag: weekday) as! CheckRow).value, checked {
                let start = (form.rowBy(tag: "\(weekday) start") as! TimeInlineRow).value
                let end = (form.rowBy(tag: "\(weekday) end") as! TimeInlineRow).value
                let pricing = (form.rowBy(tag: "\(weekday) pricing") as! DecimalRow).value

                if let start = start, let end = end, let pricing = pricing {
                    daysWithRange[weekday] = RepeatingAvailabilityTimeRange(
                        start: start.timeComponentStringIso8601(),
                        end: end.timeComponentStringIso8601(),
                        pricing: Int(pricing * 100))
                }
            }
        }

        var rangesWithDays = [RepeatingAvailabilityTimeRange: [String]]()

        for (weekday, range) in daysWithRange {
            rangesWithDays[range, default: []].append(weekday)
        }

        let numRequests = rangesWithDays.count
        var numRequestsCompleted = 0

        for (range, days) in rangesWithDays {
            if  let token = UserDefaults.standard.string(forKey: "token"),
                let parkingSpace = parkingSpace {
                RepeatingAvailability.create(withToken: token, parkingSpace: parkingSpace, timeRange: range, days: days) { error, repeatingAvailability in
                    if let error = error {
                        print("-------------------")
                        print("ERROR: \(error)")
                        print("-------------------")
                    } else {
                        numRequestsCompleted += 1
                        if numRequestsCompleted == numRequests {
                            self.performSegue(withIdentifier: "unwindToParkingSpaceDetailTableViewController", sender: self)
                        }
                    }
                }
            }
        }

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

