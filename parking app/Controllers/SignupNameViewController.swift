//
//  SignupNameViewController.swift
//  parking app
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
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        // set color here so the button is still visible in Interface Builder
        cancelButton.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        firstNameTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
