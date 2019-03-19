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

//func delete(path: String, withToken token: String?, completion: @escaping (Error?) -> Void) {
//    let headers: HTTPHeaders = [
//        "Authorization": "Token \(token)",
//    ]
//
//    Alamofire.request(
//        baseURL + "/api/parking/spaces/\(self.id)/",
//        method: .delete,
//        headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success:
//                completion(nil)
//            case .failure(let error):
//                completion(error)
//            }
//    }
//}
//
//
//doSomething(withToken: token, and: that)
