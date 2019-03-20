//
//  Reservations.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum ReservationRequest: String {
    // literal
    case get = ""
    
    // id
    case id = "/"
    case report = "/report/"
    case cancel = "/cancel/"
}

class ReservationTable {
    let url = baseURL + DatabaseUrl.reservations.rawValue
    let request: ReservationRequest
    var id = -1
    init(request: ReservationRequest, id: Int? = nil) {
        self.request = request
        if let id = id {
            self.id = id
        }
    }
    
    var path: String {
        get {
            switch(self.request) {
            case .get:
                return self.url + request.rawValue
            default:
                return self.url + "\(self.id)" + request.rawValue
            }
        }
    }
}
