//
//  AuthenticationRequiredViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationRequiredViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
