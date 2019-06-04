//
//  Spaces.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

class ParkingSpaceTable {
    var url = baseURL + DatabaseUrl.spaces.rawValue
    // literal
    let search = "search/"
    
    // id
    let id = "/"
    let availability = "/availability/"
    let repeatingAvailabilities = "/repeatingavailabilities/"
    let fixedAvailabilities = "/fixedavailabilities/"
    let futureFixedAvailabilities = "/fixedavailabilities/future/"
    let currentReservations = "/reservations/current/"
    let previousReservations = "/reservations/previous/"
    
    init(_ id: Int? = nil){
        if let id = id{
            self.url += String(id)
        }
    }
    
    func path(_ pathtype: String) -> String{
        switch pathtype {
        case "id":
            return self.url + self.id
        case "search":
            return self.url + self.search
        case "availability":
            return self.url + self.availability
        case "repeating":
            return self.url + self.repeatingAvailabilities
        case "fixed":
            return self.url + self.fixedAvailabilities
        case "future":
            return self.url + self.futureFixedAvailabilities
        case "current":
            return self.url + self.currentReservations
        case "previous":
            return self.url + self.previousReservations
        default:
            return self.url
        }
    }
}

var temp = ParkingSpaceTable().getPath(ParkingSpaceRequest.id, 123)
