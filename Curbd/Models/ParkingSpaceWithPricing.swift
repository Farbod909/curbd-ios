//
//  ParkingSpaceWithPricing.swift
//  Curbd
//
//  Created by Farbod Rafezy on 9/3/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import SwiftyJSON

class ParkingSpaceWithPricing {

    let parkingSpace: ParkingSpace
    let pricing: Int

    init(json: JSON) {
        self.parkingSpace = ParkingSpace(json: json["parking_space"])
        self.pricing = json["pricing"].intValue
    }
}
