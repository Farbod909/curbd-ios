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

    let pickerRowPlaceholder = "Choose.."

    func initializeSettings() {
        animateScroll = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()

        form
        +++ Section("Vehicle Details")
            <<< PickerInputRow<Int>("year"){
                $0.title = "Year"
                $0.options = []
                for i in 1940...2018 {
                    $0.options.append(i)
                }
                $0.value = 2018
            }
            <<< PickerInputRow<String>("make"){
                $0.title = "Make"
                $0.options = []
                for i in 1...10 {
                    $0.options.append("option \(i)")
                }
                $0.value = pickerRowPlaceholder
            }
            <<< PickerInputRow<String>("model"){
                $0.title = "Model"
                $0.options = []
                for i in 1...10 {
                    $0.options.append("option \(i)")
                }
                $0.value = pickerRowPlaceholder
                $0.disabled = Condition.function(["make"], { form in
                    if let makeRow = form.rowBy(tag: "make") as? PickerInputRow<String> {
                        return makeRow.value == self.pickerRowPlaceholder
                    }
                    return true
                })
            }
            <<< PickerInputRow<String>("color"){
                $0.title = "Color"
                $0.options = []
                for i in 1...10 {
                    $0.options.append("size \(i)")
                }
                $0.value = pickerRowPlaceholder
            }
            <<< PickerInputRow<String>("size"){
                $0.title = "Size"
                $0.options = []
                for i in 1...10 {
                    $0.options.append("option \(i)")
                }
                $0.value = pickerRowPlaceholder
            }
            <<< TextRow("licensePlate"){
                $0.title = "License Plate"
                $0.placeholder = "Not Publicly Displayed"
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @objc func saveTapped(sender: UIBarButtonItem) {

    }
}
