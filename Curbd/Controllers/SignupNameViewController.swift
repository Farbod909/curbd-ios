//
//  SignupNameViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SignupNameViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: HollowTextField!
    @IBOutlet weak var lastNameTextField: HollowTextField!

    func initializeAppearanceSettings() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(hex: "222222")
        view.backgroundColor = UIColor(hex: "222222")
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        // set color here so the button is still visible in Interface Builder
        cancelButton.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        firstNameTextField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    @IBAction func closeButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func nextButtonClick(_ sender: UIButton) {

        if firstNameTextField.text != "" && lastNameTextField.text != "" {
            if let signupEmailPhoneViewController = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(
                    withIdentifier: "signupEmailPhoneViewController") as? SignupEmailPhoneViewController {

                signupEmailPhoneViewController.firstName = firstNameTextField.text
                signupEmailPhoneViewController.lastName = lastNameTextField.text

                show(signupEmailPhoneViewController, sender: self)
            }
        } else {
            presentSingleButtonAlert(
                title: "Incomplete fields",
                message: "Please complete all fields before proceeding.")

        }

    }

}
