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
        emailField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        User.login(username: emailField.text!, password: passwordField.text!) { error in
            if error != nil {
                if let _ = error as? ValidationError {
                    self.presentSingleButtonAlert(
                        title: "Invalid Login Credentials",
                        message: "That username/password combination does not exist.")
                } else {
                    self.presentServerErrorAlert()
                }
            } else {
                self.performSegue(
                    withIdentifier: "unwindToMapViewController",
                    sender: self)
            }
        }
    }
}
