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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var hostASpaceButton: UIButton!
    @IBOutlet weak var listingsButton: UIButton!

    func initializeAppearanceSettings() {
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.insertSubview(blurEffectView, at: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        if let firstName = UserDefaults.standard.string(forKey: "user_firstname") {
            firstNameLabel.text = firstName.capitalized
        }

        let isHost = UserDefaults.standard.bool(forKey: "user_is_host")
        if isHost {
            listingsButton.isHidden = false
        } else {
            hostASpaceButton.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func exitButtonClick(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMapViewControllerAfterAuthentication", sender: self)
    }
    
}
