//
//  SignupPasswordViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Alamofire

class SignupPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
        if passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            if passwordTextField.text == confirmPasswordTextField.text {
                if  let firstName = firstName?.trim(),
                    let lastName = lastName?.trim(),
                    let email = email?.trim(),
                    let phone = phone?.trim(),
                    let password = passwordTextField.text {

                    User.create(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        phone: phone,
                        password: password) { error, user in

                            if error == nil {
                                User.login(username: email, password: password) { error in
                                    if error == nil {
                                        self.presentSingleButtonAlert(
                                            title: "Success",
                                            message: "Successfully created user.") { action in
                                                self.performSegue(
                                                    withIdentifier: "unwindToMapViewController",
                                                    sender: self)
                                        }
                                    } else {
                                        // somehow failed to login?
                                    }
                                }
                            } else {
                                if let error = error as? ValidationError {
                                    var message = ""
                                    for (_, value) in error.fields {
                                        // TODO: only capitalize first word.
                                        message += "\(value)\n".capitalized
                                    }
                                    self.presentSingleButtonAlert(
                                        title: "Invalid Fields",
                                        message: message.trimmingCharacters(in: .newlines))
                                }
                            }
                    }

                } else {
                    // somehow one or more of the user properties is nil?
                }
            } else {
                presentSingleButtonAlert(
                    title: "Password Mismatch",
                    message: "The password fields do not match.")
            }
        } else {
            presentSingleButtonAlert(
                title: "Incomplete fields",
                message: "Please complete all fields before proceeding.")
        }
    }
}
