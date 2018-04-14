//
//  ParkingSpaceViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/13/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Pulley
import UIKit

class ParkingSpaceViewController: UIViewController {

    var parkingSpace: ParkingSpace? = nil

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var availableSpacesLabel: UILabel!
    @IBOutlet weak var maxVehicleSizeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let parkingSpace = self.parkingSpace {
            self.addressLabel.text = parkingSpace.address
            self.availableSpacesLabel.text = "\(parkingSpace.available_spaces) available spaces"
            self.maxVehicleSizeLabel.text = "Max vehicle size: \(parkingSpace.size)"
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .collapsed)
        }
    }

    @IBAction func dismissButton(_ sender: Any) {
        if let pulleyVC = self.parent as? ParkingPulleyViewController
        {
//            let drawerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "drawerVC")

            pulleyVC.setDrawerContentViewController(controller: pulleyVC.savedDrawerVC!, animated: false)
            let mapVC = pulleyVC.childViewControllers[0] as! MapViewController
            mapVC.mapView.deselectAnnotation(mapVC.mapView.selectedAnnotations[0], animated: true)
            mapVC.redoSearchButton.isHidden = false
        }
    }

}

extension ParkingSpaceViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat {
        return 300
    }

    func partialRevealDrawerHeight() -> CGFloat {
        return 100
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            .open,
            .collapsed,
            .partiallyRevealed
        ]
    }
}
