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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func dismiss(_ sender: Any) {
        if let drawer = self.parent as? PulleyViewController
        {
            let drawerContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "drawerVC")

            drawer.setDrawerContentViewController(controller: drawerContent, animated: false)
        }
    }

}

extension ParkingSpaceViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat {
        return 300
    }

    func partialRevealDrawerHeight() -> CGFloat {
        return 0
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            .collapsed
        ]
    }
}
