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

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
    }
}
