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
        vehicleImageView.image = vehicleImageView.image!.withRenderingMode(.alwaysTemplate)
        vehicleImageView.tintColor = UIColor.curbdPurpleBright
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
            vehicleImageView.tintColor = UIColor.white
            makeAndModelLabel.textColor = UIColor.white
            vehicleColorLabel.textColor = UIColor.white
            licencePlateLabel.textColor = UIColor.white
            currentVehicleIndicatorLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            vehicleImageView.tintColor = UIColor.curbdPurpleBright
            makeAndModelLabel.textColor = UIColor.curbdDarkGray
            vehicleColorLabel.textColor = UIColor.curbdDarkGray
            licencePlateLabel.textColor = UIColor.curbdDarkGray
            currentVehicleIndicatorLabel.textColor = UIColor.systemGreen
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            view.backgroundColor = UIColor.curbdPurpleBright
            vehicleImageView.tintColor = UIColor.white
            makeAndModelLabel.textColor = UIColor.white
            vehicleColorLabel.textColor = UIColor.white
            licencePlateLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            vehicleImageView.tintColor = UIColor.curbdPurpleBright
            makeAndModelLabel.textColor = UIColor.curbdDarkGray
            vehicleColorLabel.textColor = UIColor.curbdDarkGray
            licencePlateLabel.textColor = UIColor.curbdDarkGray
        }

    }
}
