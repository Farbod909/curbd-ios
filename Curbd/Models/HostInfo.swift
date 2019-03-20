//
//  HostInfo.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/5/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import SwiftyJSON

class HostInfo: JSONSerializable {
    let hostSince: String // date string in the form of MM-DD-YYYY
    let venmoEmail: String?
    let venmoPhone: String?
    let hasDateOfBirth: Bool
    let hasAddress: Bool

    // sum of all of host's income from past and future reservations
    let totalEarnings: Int

    // sum of all of host's income that has not been paid out yet
    let currentBalance: Int

    // sum of all of host's income that has not been paid out and is available for pay out
    let availableBalance: Int

    required init(json: JSON) {
        self.hostSince = json["host_since"].stringValue
        self.venmoEmail = json["venmo_email"].string
        self.venmoPhone = json["venmo_phone"].string
        self.hasDateOfBirth = json["date_of_birth"] != JSON.null
        self.hasAddress = json["address"] != JSON.null
        self.totalEarnings = json["total_earnings"].intValue
        self.currentBalance = json["current_balance"].intValue
        self.availableBalance = json["available_balance"].intValue
    }

}
