//
//  RepeatingAvailability.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import SwiftyJSON

class RepeatingAvailability {

    let id: Int?
    let parking_space: Int?
    let start_time: Date
    let end_time: Date
    let repeating_days: [String]
    let pricing: Int

    init(json: JSON) {
        self.id = json["id"].intValue
        self.parking_space = json["parking_space"].intValue
        self.start_time = Formatter.iso8601.date(from: json["start_time"].stringValue)!
        self.end_time = Formatter.iso8601.date(from: json["end_time"].stringValue)!
        self.repeating_days = json["repeating_days"].stringValue.components(separatedBy: ", ")
        self.pricing = json["pricing"].intValue
    }
}
