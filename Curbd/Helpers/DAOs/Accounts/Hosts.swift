//
//  Hosts.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum HostRequest: String{
    // literal
    case get = ""
    case getSelf = "self/"
    case parkingSpaces = "self/parkingspaces/"
    case currentReservations = "self/reservations/current/"
    case previousReservations = "self/reservations/previous/"
    case verify = "self/verify/"
    
    // id
    case id = "/"
}

class HostTable {
    let url = baseURL + DatabaseUrl.hosts.rawValue
    let request: HostRequest
    var id = -1
    init(request: HostRequest, id: Int?){
        self.request = request
        if let id = id {
            self.id = id
        }
    }
    
    var path: String{
        get {
            switch(self.request) {
            case .id:
                return self.url + "\(self.id)" + request.rawValue
            default:
                return self.url + request.rawValue
            }
        }
    }
}
