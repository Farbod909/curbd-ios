//
//  ParkingSpaceDetailTableViewCell.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/14/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class ParkingSpaceDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var featuresScrollView: UIScrollView!
    @IBOutlet weak var featuresStackView: UIStackView!
    @IBOutlet weak var numberOfSpotsLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

}
