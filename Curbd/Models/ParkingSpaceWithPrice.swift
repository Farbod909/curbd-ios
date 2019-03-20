//
//  ParkingSpaceWithPricing.swift
//  Curbd
//
//  Created by Farbod Rafezy on 9/3/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import SwiftyJSON

class ParkingSpaceWithPrice: JSONSerializable {

    let parkingSpace: ParkingSpace
    let price: Int

    required init(json: JSON) {
        self.parkingSpace = ParkingSpace(json: json["parking_space"])
        self.price = json["price"].intValue
    }
}
