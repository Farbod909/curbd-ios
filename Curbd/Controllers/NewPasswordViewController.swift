//
//  NewPasswordViewController.swift
//  Curbd
//
//  Created by Ryan Dang on 2/14/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class NewPasswordViewController: UIViewController {
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    
    func initializeAppearanceSettings() {
        newPasswordTextField.underlined()
        newPasswordConfirmationTextField.underlined()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initializeAppearanceSettings()
    }
    
    @IBAction func resetPasswordButtonClick(_ sender: UIButton) {
        let newPassword = newPasswordTextField.text
        if newPassword == newPasswordConfirmationTextField.text {
//            if newPassword != "" && newPassword.isValidPassword() {
//                
//            }
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
