//
//  AddParkingSpaceViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/3/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka

class AddParkingSpaceViewController: FormViewController {
    func initializeSettings() {
        animateScroll = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next", style: .plain, target: self, action: #selector(nextButtonClick))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {
        
    }

    @objc func nextButtonClick(sender: UIBarButtonItem) {
        instantiateAndShowViewController(withIdentifier: "addAvailabilityViewController")
    }
}

