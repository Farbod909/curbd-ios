//
//  RepeatingAvailabilityTimeRange.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/20/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

struct RepeatingAvailabilityTimeRange: Hashable {

    var allDay: Bool
    var start: String?
    var end: String?
    var pricing: Int

    var hashValue: Int {
        if allDay {
            return pricing.hashValue
        } else {
            if let start = start, let end = end {
                return start.hashValue ^ end.hashValue ^ pricing.hashValue
            } else {
                return pricing.hashValue
            }
        }
    }

    static func ==(lhs: RepeatingAvailabilityTimeRange, rhs: RepeatingAvailabilityTimeRange) -> Bool {
        if lhs.allDay && rhs.allDay {
            return lhs.pricing == rhs.pricing
        } else {
            return lhs.allDay == rhs.allDay && lhs.start! == rhs.start! && lhs.end! == rhs.end! && lhs.pricing == rhs.pricing
        }
    }

}
