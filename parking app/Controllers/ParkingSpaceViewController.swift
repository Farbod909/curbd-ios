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
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .collapsed)
        }
    }

    @IBAction func dismissButton(_ sender: Any) {
        if let pulleyVC = self.parent as? PulleyViewController
        {
            let drawerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "drawerVC")

            pulleyVC.setDrawerContentViewController(controller: drawerVC, animated: false)
            let mapVC = pulleyVC.childViewControllers[0] as! MapViewController
            mapVC.mapView.deselectAnnotation(mapVC.mapView.selectedAnnotations[0], animated: true)
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
