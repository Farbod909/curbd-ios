//
//  DAO.swift
//  Curbd
//
//  Created by Ryan Dang on 3/18/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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

func DAOget(path: String,
         parameters: Parameters = [:],
         token: String? = nil,
         encoding: URLEncoding = URLEncoding.default,
         completion: @escaping (Error?, JSON?) -> Void) {
    
    var headers: HTTPHeaders = [:]
    
    if let token = token {
        headers = [
            "Authorization": "Token \(token)",
        ]
    }
    Alamofire.request(path, method: .get, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON {
        response in
        switch response.result {
        case .success(let value):
            completion(nil, JSON(value))
        case .failure(let error):
            completion(error, nil)
        }
    }
}

func getArray(path: String,
              parameters: Parameters,
              token: String?,
              arrayKey: String = "results",
              encoding: URLEncoding = URLEncoding.default,
              completion: @escaping (Error?, JSON?) -> Void) {
    var headers: HTTPHeaders = [:]
    
    if let token = token {
        headers = [
            "Authorization": "Token \(token)",
        ]
    }
    Alamofire.request(path, method: .get, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON {
        response in
        switch response.result {
        case .success(let value):
            completion(nil, JSON(value)[arrayKey])
        case .failure(let error):
            completion(error, nil)
        }
    }
}

//func post
//
//func put
//
//func patch
//
//func delete
//
