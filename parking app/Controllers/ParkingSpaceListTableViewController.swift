//
//  ParkingSpaceListTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 6/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class ParkingSpaceListTableViewController: UITableViewController {

    var parkingSpaces = [ParkingSpace]()

    func initializeSettings() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func initializeAppearanceSettings() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeAppearanceSettings()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingSpaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "parkingSpaceCell") as! ParkingSpaceTableViewCell
        let parkingSpace = parkingSpaces[indexPath.row]

        // cell.member = value

        return cell
    }

}

