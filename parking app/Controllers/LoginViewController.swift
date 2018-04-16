//
//  LoginViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        User.getToken(username: emailField.text!, password: passwordField.text!) { token in
            if let token = token {
                print("setting token to \(token)")
                UserDefaults.standard.set(token, forKey: "token")
                self.performSegue(withIdentifier: "unwindToPulley", sender: self)
            } else {
                self.presentSingleButtonAlert(
                    title: "Invalid Login Credentials",
                    message: "That username/password combination does not exist.")
            }
        }
    }
}
