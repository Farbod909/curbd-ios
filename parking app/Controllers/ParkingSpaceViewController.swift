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
    @IBOutlet weak var maxVehicleSizeLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var featuresScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.reserveButton.layer.cornerRadius = 10

        if let parkingSpace = self.parkingSpace {
            self.addressLabel.text = parkingSpace.address
            if let sizeDescription = ParkingSpace.vehicleSize[parkingSpace.size] {
                self.maxVehicleSizeLabel.text = "Max vehicle size: \(sizeDescription)"
            } else {
                self.maxVehicleSizeLabel.text = "Max vehicle size: unknown"
            }
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
        if iphoneX {
            return 250 + 26
        }
        return 250
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if iphoneX {
            return 100 + 26
        }
        return 100
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition == .partiallyRevealed {
            featuresScrollView.isHidden = true
        } else if drawer.drawerPosition == .open {
            featuresScrollView.isHidden = false
        } else if drawer.drawerPosition == .collapsed {
            featuresScrollView.isHidden = false
        }
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            .open,
            .collapsed,
            .partiallyRevealed
        ]
    }
}
