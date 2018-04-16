//
//  UserMenuViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class UserMenuViewController: UIViewController {
    
    @IBAction func logOutButtonClick(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token")
        dismiss(animated: true)
    }
}
