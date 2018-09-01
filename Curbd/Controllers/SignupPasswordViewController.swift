//
//  SignupPasswordViewController.swift
//  Curbd
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
    var loadingView = LoadingView()

    func initializeAppearanceSettings() {
        view.backgroundColor = UIColor(hex: "222222")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

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

                    startLoading(loadingView)
                    User.create(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        phone: phone,
                        password: password) { error, user in
                            self.stopLoading(self.loadingView)

                            if error != nil {
                                if let error = error as? ValidationError {
                                    self.presentValidationErrorAlert(from: error)
                                } else {
                                    self.presentServerErrorAlert()
                                }
                            } else {
                                User.login(username: email, password: password) { error in
                                    if error != nil {
                                        self.presentServerErrorAlert()
                                    } else {
                                        self.performSegue(
                                            withIdentifier: "unwindToMapViewController",
                                            sender: self)
                                    }
                                }
                            }
                    }

                } else {
                    // somehow one or more of the user properties is nil?
                    // this would never happen.
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
