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


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))

        form
        +++ Section("Vehicle Details")
        <<< TextRow() { row in
            row.title = "Make"
            row.placeholder = "Enter text here"
        }
        <<< PhoneRow() { row in
            row.title = "Phone Row"
            row.placeholder = "And numbers here"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @objc func saveTapped(sender: UIBarButtonItem) {

    }
}
