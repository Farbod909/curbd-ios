//
//  LoginViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: DarkTranslucentViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        User.getToken(username: emailField.text!, password: passwordField.text!) { token in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "token")

                User.getCurrentUserInfo() { user in
                    if let user = user {
                        // TODO: possibly encode an entire User object into UserDefaults
                        UserDefaults.standard.set(user.id, forKey: "user_id")
                        UserDefaults.standard.set(user.firstName, forKey: "user_firstname")
                        UserDefaults.standard.set(user.lastName, forKey: "user_lastname")
                        UserDefaults.standard.set(user.email, forKey: "user_email")
                        UserDefaults.standard.set(user.isHost, forKey: "user_is_host")

                    }
                }

                User.getCurrentUserVehicles() { vehicles in
                    if let vehicles = vehicles {
                        if let firstVehicle = vehicles.first {
                            UserDefaults.standard.set(
                                firstVehicle.licensePlate, forKey: "vehicle_license_plate")
                            UserDefaults.standard.set(
                                firstVehicle.id, forKey: "vehicle_id")
                            UserDefaults.standard.set(
                                firstVehicle.size, forKey: "vehicle_size")
                        }
                    }
                    // unwind to pulley view controller only after receiving
                    // user vehicle information.
                    self.performSegue(
                        withIdentifier: "unwindToMapViewController",
                        sender: self)
                }

                
            } else {
                self.presentSingleButtonAlert(
                    title: "Invalid Login Credentials",
                    message: "That username/password combination does not exist.")
            }
        }
    }
}
