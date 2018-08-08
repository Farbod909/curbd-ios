//
//  SettingsTableViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/22/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBAction func dismissButtonClick(_ sender: UIBarButtonItem) {
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
