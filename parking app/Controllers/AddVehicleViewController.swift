//
//  AddVehicleViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/29/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka

class AddVehicleViewController: FormViewController {

    func initializeSettings() {
        animateScroll = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save", style: .done, target: self, action: #selector(saveTapped))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()

        if let yearRow = form.rowBy(tag: "year") as? PushRow<Int> {
            CarQuery.getYears() { error, yearRange in
                if let yearRange = yearRange {
                    for year in yearRange.reversed() {
                        yearRow.options?.append(year)
                    }
                }
            }
        }

    }

    func initializeForm() {
        form
        +++ Section("Details")
            <<< PushRow<Int>("year") {
                $0.title = $0.tag?.capitalized
                $0.options = []
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }.onChange() { yearRow in
                if  let makeRow = self.form.rowBy(tag: "make") as? PushRow<String>,
                    let modelRow = self.form.rowBy(tag: "model") as? PushRow<String> {
                    makeRow.value = nil
                    modelRow.value = nil
                    if let year = yearRow.value {
                        CarQuery.getMakes(year: year) { error, makes in
                            if let makes = makes {
                                makeRow.options = makes
                            }
                        }
                    }
                }
            }
            <<< PushRow<String>("make") {
                $0.title = $0.tag?.capitalized
                $0.options = []
                $0.disabled = Condition.function(["year"], { form in
                    if let yearRow = form.rowBy(tag: "year") as? PushRow<Int> {
                        return yearRow.value == nil
                    }
                    return true
                })
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }.onChange() { makeRow in
                if let modelRow = self.form.rowBy(tag: "model") as? PushRow<String> {
                    modelRow.value = nil
                    if  let make = makeRow.value,
                        let year = (self.form.rowBy(tag: "year") as? PushRow<Int>)?.value {
                        CarQuery.getModels(make: make, year: year) { error, models in
                            if let models = models {
                                modelRow.options = models
                            }
                        }
                    }
                }
            }
            <<< PushRow<String>("model") {
                $0.title = $0.tag?.capitalized
                $0.options = []
                for i in 1...10 {
                    $0.options?.append("model \(i)")
                }
                $0.disabled = Condition.function(["year", "make"], { form in
                    if  let yearRow = form.rowBy(tag: "year") as? PushRow<Int>,
                        let makeRow = form.rowBy(tag: "make") as? PushRow<String> {
                        return yearRow.value == nil || makeRow.value == nil
                    }
                    return true
                })
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            <<< PushRow<String>("color") {
                $0.title = $0.tag?.capitalized
                $0.options = [
                    "White",
                    "Black",
                    "Silver",
                    "Gray",
                    "Red",
                    "Blue",
                    "Green",
                    "Yellow/Gold",
                    "Brown/Beige",
                    "Orange",
                    "Purple",
                    "Pink",
                    "Other"
                ]
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            <<< PushRow<String>("size") {
                $0.title = $0.tag?.capitalized
                $0.options = []
                for size in Array(Vehicle.sizes.keys).sorted() {
                    if size != 1 {
                        $0.options?.append(Vehicle.sizes[size]!)
                    }
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            <<< TextRow("license plate") {
                $0.title = $0.tag?.capitalized
                $0.placeholder = "Not Publicly Displayed"
            }
    }

    @objc func saveTapped(sender: UIBarButtonItem) {
        if  let year = (form.rowBy(tag: "year") as? PushRow<Int>)?.value,
            let make = (form.rowBy(tag: "make") as? PushRow<String>)?.value,
            let model = (form.rowBy(tag: "model") as? PushRow<String>)?.value,
            let color = (form.rowBy(tag: "color") as? PushRow<String>)?.value,
            let sizeString = (form.rowBy(tag: "size") as? PushRow<String>)?.value,
            let size = (Vehicle.sizes as NSDictionary).allKeys(for: sizeString).first as? Int,
            let licensePlate = (form.rowBy(tag: "license plate") as? TextRow)?.value {

            if let token = UserDefaults.standard.string(forKey: "token") {
                Vehicle.create(
                    withToken: token,
                    year: year,
                    make: make,
                    model: model,
                    color: color,
                    size: size,
                    licensePlate: licensePlate) { error, vehicle in

                        if let vehicle = vehicle {
                            vehicle.setAsCurrentVehicle()
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            if let error = error as? ValidationError {
                                self.presentValidationErrorAlert(from: error)
                            } else {
                                self.presentServerErrorAlert()
                            }
                        }

                }
            }

        } else {
            presentSingleButtonAlert(
                title: "Incomplete Fields",
                message: "Please make sure all fields are completed.")
        }
    }
}
