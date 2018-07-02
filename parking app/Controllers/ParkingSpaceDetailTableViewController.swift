//
//  ParkingSpaceDetailTableViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/2/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class ParkingSpaceDetailTableViewController: UITableViewController {

    var parkingSpace: ParkingSpace?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceAddressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!

    func initializeAppearanceSettings() {
//        featuresScrollView.showsHorizontalScrollIndicator = false
    }

    override func viewDidLoad() {
        initializeAppearanceSettings()
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
}

