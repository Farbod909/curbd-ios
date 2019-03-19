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

    var passwordResetToken: String? = nil

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
        if let newPassword = newPasswordTextField.text,
            let newPasswordConfirmation = newPasswordConfirmationTextField.text,
            let passwordResetToken = passwordResetToken {
            if newPassword == newPasswordConfirmation {
    //        if newPassword != "" && newPassword.isValidPassword() {
                User.confirmForgetPasswordReset(token: passwordResetToken, newPassword: newPassword) { error in
                    if error == nil {
                        self.presentSingleButtonAlert(title: "Success", message: "Your password was reset successfully.", buttonText: "OK") { action in
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.presentServerErrorAlert()
                    }
                }
    //        }
            } else {
                presentSingleButtonAlert(
                    title: "Password Mismatch",
                    message: "The password fields do not match.")
            }
        } else {
            print("Error")
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
