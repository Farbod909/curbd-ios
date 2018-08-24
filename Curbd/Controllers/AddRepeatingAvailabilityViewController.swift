//
//  AddAvailabilityViewController.swift
//  Curbd
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done", style: .done, target: self, action: #selector(doneButtonClick))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        TimeInlineRow.defaultCellSetup = { cell, row in
            row.minuteInterval = 5
        }

        for (index, weekday) in weekdays.enumerated() {

            form
                +++ (index == 0 ? Section("select weekdays") : Section() {
                    $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
                    $0.header?.height = { CGFloat.leastNormalMagnitude }
                })
                <<< CheckRow(weekday) {
                    $0.title = weekdaysFull[index]
                    $0.value = false
                }
                <<< SwitchRow("\(weekday) all_day") {
                    $0.title = "All day"
                    $0.value = true
                    $0.hidden = Condition(stringLiteral: "$\(weekday) == false")
                }
                <<< TimeInlineRow("\(weekday) start"){
                    $0.title = "From"
                    $0.value = Date().ceil(precision: 300)
                    $0.hidden = Condition.function(["\(weekday)", "\(weekday) all_day"], { form in
                        let weekdayChecked = (form.rowBy(tag: "\(weekday)") as? CheckRow)?.value ?? false
                        let allDayChecked = (form.rowBy(tag: "\(weekday) all_day") as? SwitchRow)?.value ?? false
                        return !weekdayChecked || allDayChecked
                    })
                }
                <<< TimeInlineRow("\(weekday) end"){
                    $0.title = "Until"
                    $0.value = Date(timeInterval: 7200, since: Date()).ceil(precision: 300)
                    $0.hidden = Condition.function(["\(weekday)", "\(weekday) all_day"], { form in
                        let weekdayChecked = (form.rowBy(tag: "\(weekday)") as? CheckRow)?.value ?? false
                        let allDayChecked = (form.rowBy(tag: "\(weekday) all_day") as? SwitchRow)?.value ?? false
                        return !weekdayChecked || allDayChecked
                    })
                }
                <<< DecimalRow("\(weekday) pricing"){
                    $0.useFormatterDuringInput = true
                    $0.title = "Hourly price"
                    $0.value = 1
                    let formatter = CurrencyFormatter()
                    formatter.locale = .current
                    formatter.numberStyle = .currency
                    $0.formatter = formatter
                    $0.hidden = Condition(stringLiteral: "$\(weekday) == false")
                }
        }

    }

    @objc func doneButtonClick(_ sender: UIBarButtonItem) {

        var daysWithRange = [String: RepeatingAvailabilityTimeRange]()

        for weekday in weekdays {
            if let checked = (form.rowBy(tag: weekday) as! CheckRow).value, checked {
                let allDay = ((form.rowBy(tag: "\(weekday) all_day") as! SwitchRow).value)!
                if allDay {

                    let pricing = (form.rowBy(tag: "\(weekday) pricing") as! DecimalRow).value
                    if let pricing = pricing {
                        daysWithRange[weekday] = RepeatingAvailabilityTimeRange(
                            allDay: true,
                            start: nil,
                            end: nil,
                            pricing: Int(pricing * 100))
                    }

                } else {

                    let start = (form.rowBy(tag: "\(weekday) start") as! TimeInlineRow).value
                    let end = (form.rowBy(tag: "\(weekday) end") as! TimeInlineRow).value
                    let pricing = (form.rowBy(tag: "\(weekday) pricing") as! DecimalRow).value

                    if let start = start, let end = end, let pricing = pricing {
                        daysWithRange[weekday] = RepeatingAvailabilityTimeRange(
                            allDay: false,
                            start: start.timeComponentStringIso8601(),
                            end: end.timeComponentStringIso8601(),
                            pricing: Int(pricing * 100))
                    }

                }

            }
        }

        var rangesWithDays = [RepeatingAvailabilityTimeRange: [String]]()

        for (weekday, range) in daysWithRange {
            rangesWithDays[range, default: []].append(weekday)
        }

        let numRequests = rangesWithDays.count
        var numRequestsCompleted = 0

        if numRequests == 0 {
            performSegue(withIdentifier: "unwindToParkingSpaceDetailTableViewController", sender: self)
        }

        for (range, days) in rangesWithDays {
            if  let token = UserDefaults.standard.string(forKey: "token"),
                let parkingSpace = parkingSpace {
                RepeatingAvailability.create(withToken: token, parkingSpace: parkingSpace, timeRange: range, days: days) { error, repeatingAvailability in
                    if let error = error {
                        self.presentServerErrorAlert()
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
