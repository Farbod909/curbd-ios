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

        let startTime = json["start_time"].stringValue
        let endTime = json["end_time"].stringValue

        let minuteStartIndex = startTime.index(startTime.startIndex, offsetBy: 3)
        let minuteEndIndex = startTime.index(startTime.startIndex, offsetBy: 5)

        let startHour = Int(startTime.prefix(2))!
        let startMinute = Int(startTime[minuteStartIndex..<minuteEndIndex])!

        let endHour = Int(endTime.prefix(2))!
        let endMinute = Int(endTime[minuteStartIndex..<minuteEndIndex])!

        self.start_time = Calendar.current.date(bySettingHour: startHour, minute: startMinute, second: 0, of: Date())!
        self.end_time = Calendar.current.date(bySettingHour: endHour, minute: endMinute, second: 0, of: Date())!


        self.repeating_days = json["repeating_days"].stringValue.components(separatedBy: ", ")
        self.pricing = json["pricing"].intValue
    }
}
