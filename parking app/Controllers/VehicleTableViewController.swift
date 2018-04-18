//
//  VehicleTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

class VehicleTableViewController: UITableViewController {

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "vehicleCell") as! VehicleTableViewCell
        cell.makeAndModelLabel.text = "Honda Accord"
        cell.vehicleColorLabel.text = "Color: black"
        cell.licencePlateLabel.text = "7APF827"
        return cell
    }
}

//extension VehicleTableViewController: UITableViewDelegate {
//
//}
//
//extension VehicleTableViewController: UITableViewDataSource {
//
//}

