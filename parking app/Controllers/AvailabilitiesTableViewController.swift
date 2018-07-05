//
//  AvailabilitiesTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class AvailabilitiesTableViewController: UITableViewController {

    var parkingSpace: ParkingSpace?
    var repeatingAvailabilities = [RepeatingAvailability]()
    var fixedAvailabilities = [FixedAvailability]()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let parkingSpace = parkingSpace {
            if let parkingSpaceId = parkingSpace.id {
                // TODO: get availabilities
            } else {
                // there are no availabilities to get
                // this is because the parking space was just
                // created, hence why "id" is nil
                // TODO: display "no availabilities yet; add one!"?
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatingAvailabilities.count + fixedAvailabilities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < repeatingAvailabilities.count {
            let repeatingAvailabilityCell = tableView.dequeueReusableCell(
                withIdentifier: "repeatingAvailabilityCell") as! RepeatingAvailabilityTableViewCell
            let repeatingAvailability = repeatingAvailabilities[indexPath.row]
            repeatingAvailabilityCell.repeatingDaysLabel.text = repeatingAvailability.repeating_days.joined(separator: ", ")
            repeatingAvailabilityCell.timeRangeLabel.text =
                "\(repeatingAvailability.start_time.toHumanReadable()) - \(repeatingAvailability.end_time.toHumanReadable())"

            return repeatingAvailabilityCell
        } else {
            let fixedAvailabilityCell = tableView.dequeueReusableCell(
                withIdentifier: "fixedAvailabilityCell") as! FixedAvailabilityTableViewCell
            let fixedAvailability = fixedAvailabilities[indexPath.row - repeatingAvailabilities.count]
            fixedAvailabilityCell.startDateTimeLabel.text = fixedAvailability.start_datetime.toHumanReadable()
            fixedAvailabilityCell.endDateTimeLabel.text = fixedAvailability.end_datetime.toHumanReadable()

            return fixedAvailabilityCell
        }

    }

    @IBAction func unwindToAvailabilitiesViewController(segue:UIStoryboardSegue) { }
}
