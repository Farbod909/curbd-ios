//
//  ParkingPulleyViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/14/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Pulley

class ParkingPulleyViewController: PulleyViewController {

    // the search drawer view controller is saved in this
    // variable when the pulley sets its drawer view
    // controller to a parking space detail view controller.
    // This allowscthe drawer to return to its original
    // state when the search drawer view controller is restored.
    var savedSearchDrawerViewController: SearchDrawerViewController? = nil

    /**
     This function is called when another view controller
     unwinds to this view controller.

     Currently it does not need to do anything. It is just
     referenced in the Interface builder as an outlet.
     */
    @IBAction func unwindToPulleyViewController(segue: UIStoryboardSegue) {

    }
}
