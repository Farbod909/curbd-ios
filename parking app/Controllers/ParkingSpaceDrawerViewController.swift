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

class ParkingSpaceDrawerViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var maxVehicleSizeLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var featuresScrollView: UIScrollView!

    var parkingSpace: ParkingSpace? = nil
    let partialRevealHeight: CGFloat = 100
    let collapsedHeight: CGFloat = 240
    let drawerPositions: [PulleyPosition] = [
        .open,
        .partiallyRevealed,
        .collapsed,
    ]

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
//            let searchDrawerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchDrawerVC")

            pulleyVC.setDrawerContentViewController(controller: pulleyVC.savedSearchDrawerVC!, animated: false)
            let mapVC = pulleyVC.childViewControllers[0] as! MapViewController
            mapVC.mapView.deselectAnnotation(mapVC.mapView.selectedAnnotations[0], animated: true)
            mapVC.redoSearchButton.isHidden = false
        }
    }

}

extension ParkingSpaceDrawerViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat {
        if iphoneX {
            return collapsedHeight + 26
        }
        return collapsedHeight
    }

    func partialRevealDrawerHeight() -> CGFloat {
        if iphoneX {
            return partialRevealHeight + 26
        }
        return partialRevealHeight
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
        return drawerPositions
    }
}
