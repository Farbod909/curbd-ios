//
//  SignupPasswordViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

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
                // User.create()
            } else {
                // alert passwords do not match
            }
        } else {
            // alert please complete all fields
        }
    }
}
