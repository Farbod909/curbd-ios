//
//  RepeatingAvailabilities.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum RepeatingAvailabilitiesRequest: String {
    // literal
    case get = ""
    
    // id
    case id = "/"
}

class RepeatingAvailabilitiesTable {
    let url = baseURL + DatabaseUrl.repeatingAvailabilities.rawValue
    let request: RepeatingAvailabilitiesRequest
    var id = -1
    init(request: RepeatingAvailabilitiesRequest, id: Int? = nil) {
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
