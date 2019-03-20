//
//  Users.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation

enum UserRequest: String {
    // literal
    case get = ""
    case getSelf = "self/"
    
    // id
    case id = "/"
    case customer = "/customer/"
    case host = "/host/"
    case changePassword = "/change_password/"
    case resetPassword = "/reset_password/"
}

class UserTable {
    let url = baseURL + DatabaseUrl.users.rawValue
    let request: UserRequest
    var id = -1
    init(request: UserRequest, id: Int? = nil) {
        self.request = request
        if let id = id {
            self.id = id
        }
    }
    
    var path: String{
        get {
            switch(self.request) {
            case .get, .getSelf:
                return self.url + request.rawValue
            default:
                return self.url + "\(self.id)" + request.rawValue
            }
        }
    }
}
