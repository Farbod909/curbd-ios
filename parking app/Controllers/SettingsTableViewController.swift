//
//  SettingsTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/22/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    func initializeAppearanceSettings() {
        navigationController?.navigationBar.barTintColor = UIColor(hex: "222222")
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                User.logout() {
                    self.performSegue(
                        withIdentifier: "unwindToMapViewController", sender: self)
                }
            }
        }
    }

}
