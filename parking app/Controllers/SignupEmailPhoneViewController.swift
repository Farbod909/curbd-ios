//
//  SignupEmailPhoneViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SignupEmailPhoneViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
    }

}
