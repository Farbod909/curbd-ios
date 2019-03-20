//
//  Spaces.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum ParkingSpaceRequest: String {
    // literal
    case get = ""
    case search = "search/"
    
    // id
    case id = "/"
    case availability = "/availability/"
    case repeatingAvailabilities = "/repeatingavailabilities/"
    case fixedAvailabilities = "/fixedavailabilities/"
    case futureFixedAvailabilities = "/fixedavailabilities/future/"
    case currentReservations = "/reservations/current/"
    case previousReservations = "/reservations/previous/"
}

class ParkingSpaceTable {
    let url = baseURL + DatabaseUrl.spaces.rawValue
    let request: ParkingSpaceRequest
    var id = -1
    init(request: ParkingSpaceRequest, id: Int? = nil) {
        self.request = request
        if let id = id {
            self.id = id
        }
    }
    
    var path: String {
        get {
            switch(self.request) {
            case .get, .search:
                return self.url + request.rawValue
            default:
                return self.url + "\(self.id)" + request.rawValue
            }
        }
    }
}
