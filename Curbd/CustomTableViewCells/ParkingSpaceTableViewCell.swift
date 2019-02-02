//
//  ParkingSpaceTableViewCell.swift
//  Curbd
//
//  Created by Farbod Rafezy on 6/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import MapKit

class ParkingSpaceTableViewCell: UITableViewCell {

    var parkingSpace: ParkingSpace?
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingSpaceCityAndStateLabel: UILabel!
    @IBOutlet weak var parkingSpaceIsActiveLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.10
        self.clipsToBounds = false
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            view.backgroundColor = UIColor.curbdPurpleBright
            parkingSpaceNameLabel.textColor = UIColor.white
            parkingSpaceCityAndStateLabel.textColor = UIColor.white
            parkingSpaceIsActiveLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            parkingSpaceNameLabel.textColor = UIColor.curbdDarkGray
            parkingSpaceCityAndStateLabel.textColor = UIColor.curbdDarkGray
            if let isActive = parkingSpace?.is_active {
                parkingSpaceIsActiveLabel.textColor =
                    isActive ? UIColor.systemGreen : UIColor.systemGray
            }
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            view.backgroundColor = UIColor.curbdPurpleBright
            parkingSpaceNameLabel.textColor = UIColor.white
            parkingSpaceCityAndStateLabel.textColor = UIColor.white
            parkingSpaceIsActiveLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            parkingSpaceNameLabel.textColor = UIColor.curbdDarkGray
            parkingSpaceCityAndStateLabel.textColor = UIColor.curbdDarkGray
            if let isActive = parkingSpace?.is_active {
                parkingSpaceIsActiveLabel.textColor =
                    isActive ? UIColor.systemGreen : UIColor.systemGray
            }
        }

    }

}
