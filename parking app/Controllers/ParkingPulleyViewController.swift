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

    // the drawer view controller is saved in this variable
    // when the drawer sets its view controller to a
    // parking space detail view controller. This allows
    // the drawer to return to its original state when
    // the drawer view controller is restored
    var savedSearchDrawerVC: SearchDrawerViewController? = nil
}
