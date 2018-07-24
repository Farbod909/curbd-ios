//
//  UserMenuViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class UserMenuViewController: DarkTranslucentViewController {
    
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

    @IBAction func closeButtonClick(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMapViewController", sender: self)
    }

    @IBAction func unwindToUserMenuViewController(segue:UIStoryboardSegue) {
        UserDefaults.standard.set(true, forKey: "user_is_host")
        listingsButton.isHidden = false
        hostASpaceButton.isHidden = true
    }
    
}
