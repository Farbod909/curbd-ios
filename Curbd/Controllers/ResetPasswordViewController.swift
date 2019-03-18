//
//  ResetPasswordViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 2/13/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
        if let email = emailTextField.text, email.isValidEmail() {
            Alamofire.request(
                baseURL + "/api/accounts/forget_password/",
                method: .post,
                parameters: ["email": email]).validate().responseJSON { response in
                    switch response.result {
                    case .success( _):
                        self.presentSingleButtonAlert(title: "Email Sent", message: "We've sent an email to \(email.lowercased()). \nPlease check your inbox. This may take a few minutes.")
                    case .failure(let error):
                        self.presentServerErrorAlert()
                        print(error)
                    }
            }
        } else {
            self.presentSingleButtonAlert(title: "Invalid Email", message: "Please enter a valid email.")
        }

    }
    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
