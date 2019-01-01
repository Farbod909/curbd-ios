//
//  VehicleTableViewCell.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var makeAndModelLabel: UILabel!
    @IBOutlet weak var vehicleColorLabel: UILabel!
    @IBOutlet weak var licencePlateLabel: UILabel!
    @IBOutlet weak var currentVehicleIndicatorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.10
        self.clipsToBounds = false
    }

}
