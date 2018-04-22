//
//  SettingsTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/22/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_firstname")
        UserDefaults.standard.removeObject(forKey: "user_lastname")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_is_host")
        UserDefaults.standard.removeObject(forKey: "vehicle_license_plate")
        UserDefaults.standard.removeObject(forKey: "vehicle_id")

        performSegue(withIdentifier: "unwindToMapViewControllerAfterAuthentication", sender: self)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                logout()
            }
        }
    }

}
