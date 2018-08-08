//
//  AuthenticationRequiredViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationRequiredViewController: DarkTranslucentViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
