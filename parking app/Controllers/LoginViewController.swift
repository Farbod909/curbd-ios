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

    @IBAction func backButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        User.getToken(username: emailField.text!, password: passwordField.text!) { token in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "token")
                self.performSegue(withIdentifier: "unwindToPulley", sender: self)

                User.getUserInfo(with: token) { user in
                    if let user = user {
                        // TODO: possibly encode an entire User object into UserDefaults
                        UserDefaults.standard.set(user.id, forKey: "user_id")
                        UserDefaults.standard.set(user.firstName, forKey: "user_firstname")
                        UserDefaults.standard.set(user.lastName, forKey: "user_lastname")
                        UserDefaults.standard.set(user.email, forKey: "user_email")
                    }
                }
            } else {
                self.presentSingleButtonAlert(
                    title: "Invalid Login Credentials",
                    message: "That username/password combination does not exist.")
            }
        }
    }
}
