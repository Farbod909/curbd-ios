//
//  RepeatingAvailabilityTimeRange.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/20/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

struct RepeatingAvailabilityTimeRange: Hashable {

    var start: String
    var end: String
    var pricing: Int

    var hashValue: Int {
        return start.hashValue ^ end.hashValue ^ pricing.hashValue
    }

    static func ==(lhs: RepeatingAvailabilityTimeRange, rhs: RepeatingAvailabilityTimeRange) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end && lhs.pricing == rhs.pricing
    }

}
