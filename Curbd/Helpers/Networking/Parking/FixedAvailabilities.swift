//
//  FixedAvailabilities.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum FixedAvailabilitiesRequest: String {
    // literal
    case get = ""
    
    // id
    case id = "/"
}

class FixedAvailabilitiesTable {
    let url = baseURL + DatabaseUrl.fixedAvailabilities.rawValue
    let request: FixedAvailabilitiesRequest
    var id = -1
    init(request: FixedAvailabilitiesRequest, id: Int? = nil) {
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
