//
//  FixedAvailability.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import SwiftyJSON

class FixedAvailability {

    let id: Int?
    let parking_space: Int?
    let start_datetime: Date
    let end_datetime: Date
    let pricing: Int

    init(json: JSON) {
        self.id = json["id"].intValue
        self.parking_space = json["parking_space"].intValue
        self.start_datetime = Formatter.iso8601.date(from: json["start_datetime"].stringValue)!
        self.end_datetime = Formatter.iso8601.date(from: json["end_datetime"].stringValue)!
        self.pricing = json["pricing"].intValue
    }

}
