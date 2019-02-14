//
//  ResetPasswordViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 2/13/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    func initializeAppearanceSettings() {
        emailTextField.underlined()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

    }

    @IBAction func resetPasswordButtonClick(_ sender: UIButton) {

        User.sendResetPasswordEmail(email: "kldsjf") { error in
            print(error)
        }

    }
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
