//
//  AddVehicleViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/29/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka

class AddVehicleViewController: FormViewController, LoadingViewProtocol {

    var loadingView = LoadingView()

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
                                makeRow.disabled = false
                                makeRow.evaluateDisabled()
                            }
                        }
                    }
                }
            }
            <<< PushRow<String>("make") { row in
                row.title = row.tag?.capitalized
                row.options = []
                row.disabled = Condition.function(["year"], { form in
                    if let yearRow = form.rowBy(tag: "year") as? PushRow<Int> {
                        return yearRow.value == nil || (row.options?.isEmpty)!
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
                                modelRow.disabled = false
                                modelRow.evaluateDisabled()
                            }
                        }
                    }
                }
            }
            <<< PushRow<String>("model") { row in
                row.title = row.tag?.capitalized
                row.options = []
                row.disabled = Condition.function(["year", "make"], { form in
                    if  let yearRow = form.rowBy(tag: "year") as? PushRow<Int>,
                        let makeRow = form.rowBy(tag: "make") as? PushRow<String> {
                        return yearRow.value == nil || makeRow.value == nil || (row.options?.isEmpty)!
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
                for size in Array(Vehicle.sizeDescriptions.keys).sorted() {
                    if size > 1 {
                        $0.options?.append(Vehicle.sizeDescriptions[size]!)
                    }
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            <<< TextRow("license plate") {
                $0.title = $0.tag?.capitalized
                $0.placeholder = "Not Publicly Displayed"
                $0.useFormatterDuringInput = true
                $0.formatter = UppercaseFormatter()
            }
    }

    @objc func saveTapped(sender: UIBarButtonItem) {
        if  let year = (form.rowBy(tag: "year") as? PushRow<Int>)?.value,
            let make = (form.rowBy(tag: "make") as? PushRow<String>)?.value,
            let model = (form.rowBy(tag: "model") as? PushRow<String>)?.value,
            let color = (form.rowBy(tag: "color") as? PushRow<String>)?.value,
            let sizeString = (form.rowBy(tag: "size") as? PushRow<String>)?.value,
            let size = (Vehicle.sizeDescriptions as NSDictionary).allKeys(for: sizeString).first as? Int,
            let licensePlate = (form.rowBy(tag: "license plate") as? TextRow)?.value {

            if let token = UserDefaults.standard.string(forKey: "token") {
                startLoading()
                Vehicle.create(
                    withToken: token,
                    year: year,
                    make: make,
                    model: model,
                    color: color,
                    size: size,
                    licensePlate: licensePlate) { error, vehicle in
                        self.stopLoading()

                        if let vehicle = vehicle {
                            vehicle.setAsCurrentVehicle()
                            self.performSegue(withIdentifier: "unwindToVehiclesListAfterModifying", sender: self)
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

    func startLoading() {
        view.addSubview(loadingView)
        loadingView.start()

        // disable 'save' button
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func stopLoading() {
        loadingView.stop()
        loadingView.removeFromSuperview()

        // enable 'save' button again
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

}
