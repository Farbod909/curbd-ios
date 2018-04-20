//
//  Vehicle.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Vehicle {

    let id: Int
    let make: String
    let model: String
    let color: String
    let licensePlate: String

    init(json: JSON) {
        self.id = json["id"].intValue
        self.make = json["make"].stringValue
        self.model = json["model"].stringValue
        self.color = json["color"].stringValue
        self.licensePlate = json["license_plate"].stringValue
    }
    
}
