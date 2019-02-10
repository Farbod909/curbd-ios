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
        navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.curbdPurpleBright]
        navigationController?.navigationBar.tintColor = UIColor.curbdPurpleBright
        // set color here so the button is still visible in Interface Builder
        cancelButton.tintColor = UIColor.curbdPurpleBright

        firstNameTextField.underlined()
        lastNameTextField.underlined()

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

                signupEmailPhoneViewController.firstName = firstNameTextField.text?.trim()
                signupEmailPhoneViewController.lastName = lastNameTextField.text?.trim()

                show(signupEmailPhoneViewController, sender: self)
            }
        } else {
            presentSingleButtonAlert(
                title: "Incomplete fields",
                message: "Please complete all fields before proceeding.")

        }

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
