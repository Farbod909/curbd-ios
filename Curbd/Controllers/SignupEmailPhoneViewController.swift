//
//  SignupEmailPhoneViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SignupEmailPhoneViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    var firstName: String?
    var lastName: String?

    func initializeAppearanceSettings() {
        view.backgroundColor = UIColor(hex: "222222")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        emailTextField.becomeFirstResponder()
    }

    @IBAction func nextButtonClick(_ sender: UIButton) {

        if emailTextField.text != "" && phoneTextField.text != "" {
            if let signupPasswordViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(
                    withIdentifier: "signupPasswordViewController") as? SignupPasswordViewController {

                signupPasswordViewController.firstName = firstName
                signupPasswordViewController.lastName = lastName
                signupPasswordViewController.email = emailTextField.text
                signupPasswordViewController.phone = phoneTextField.text

                show(signupPasswordViewController, sender: self)
            }
        } else {
            presentSingleButtonAlert(
                title: "Incomplete fields",
                message: "Please complete all fields before proceeding.")
        }

    }
}
