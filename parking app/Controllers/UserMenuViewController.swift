//
//  UserMenuViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class UserMenuViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let firstName = UserDefaults.standard.string(forKey: "user_firstname") {
            firstNameLabel.text = firstName
        }
    }

    @IBAction func exitButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func logOutButtonClick(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_firstname")
        UserDefaults.standard.removeObject(forKey: "user_lastname")
        UserDefaults.standard.removeObject(forKey: "user_email")
        dismiss(animated: true)
    }
}
