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
    @IBOutlet weak var hostASpaceButton: UIButton!
    @IBOutlet weak var listingsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let firstName = UserDefaults.standard.string(forKey: "user_firstname") {
            firstNameLabel.text = firstName.capitalized
        }

        let isHost = UserDefaults.standard.bool(forKey: "user_is_host")
        if isHost {
            listingsButton.isHidden = false
        } else {
            hostASpaceButton.isHidden = false
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
        UserDefaults.standard.removeObject(forKey: "user_is_host")
        dismiss(animated: true)
    }
}
