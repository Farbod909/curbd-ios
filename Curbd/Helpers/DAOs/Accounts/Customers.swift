//
//  Customers.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum CustomerRequest: String {
    // literal
    case get = ""
    case getSelf = "self/"
    case currentReservations = "self/reservations/current/"
    case previousReservations = "self/reservations/previous/"
    
    // id
    case id = "/"
}

class CustomerTable {
    let url = baseURL + DatabaseUrl.customers.rawValue
    let request: CustomerRequest
    var id = -1
    init(request: CustomerRequest, id: Int?){
        self.request = request
        if let id = id {
            self.id = id
        }
    }
    
    var path: String{
        get {
            switch(self.request) {
            case .id:
                return self.url + "\(self.id)" + self.request.rawValue
            default:
                return self.url + self.request.rawValue
            }
        }
    }
}
