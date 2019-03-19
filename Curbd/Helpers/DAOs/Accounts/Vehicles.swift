//
//  Vehicles.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum VehicleRequest: String {
    // literal
    case get = ""
    
    // id
    case id = "/"
}

class VehicleTable {
    let url = baseURL + DatabaseUrl.vehicles.rawValue
    let request: VehicleRequest
    var id = -1
    init(request: VehicleRequest, id: Int?) {
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
