//
//  LoginViewController.swift
//  Curbd
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

    var loadingView = LoadingView()

    override func viewDidLoad() {
        emailField.becomeFirstResponder()
    }

    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        startLoading(loadingView)
        User.login(username: emailField.text!, password: passwordField.text!) { error in
            self.stopLoading(self.loadingView)
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
