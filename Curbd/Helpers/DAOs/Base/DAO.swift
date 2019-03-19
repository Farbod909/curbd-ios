//
//  DAO.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import Alamofire

enum DatabaseUrl: String {
    case api = "/api/"
    case auth = "/api/auth/"
    
    //accounts
    case users = "/api/accounts/users/"
    case customers = "/api/accounts/customers/"
    case hosts = "/api/accounts/hosts/"
    case vehicles = "/api/accounts/vehicles/"
    
    //parking
    case spaces = "/api/parking/spaces/"
    case fixedAvailabilities = "/api/parking/fixedavailabilities/"
    case repeatingAvailabilities = "/api/parking/repeatingavailabilities/"
    case reservations = "/api/parking/reservations/"
}
