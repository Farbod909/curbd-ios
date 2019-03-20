//
//  Networking.swift
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

class Networking {
    static func getObject<T: JSONSerializable>(
        path: String,
        objectType: T.Type,
        parameters: Parameters = [:],
        token: String? = nil,
        encoding: URLEncoding = URLEncoding.default,
        completion: @escaping (Error?, T?) -> Void) {
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }
        
        Alamofire.request(path, method: .get, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let responseJSON = JSON(value)
                let obj = T(json: responseJSON)
                completion(nil, obj)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    static func getArray<T: JSONSerializable>(
        path: String,
        objectType: T.Type,
        parameters: Parameters,
        token: String?,
        arrayKey: String = "results",
        encoding: URLEncoding = .default,
        completion: @escaping (Error?, [T]?) -> Void) {
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }
        
        Alamofire.request(path, method: .get, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let resultJSON = JSON(value)[arrayKey]
                
                let objects = resultJSON.arrayValue.map() {
                    T(json: $0)
                }
                completion(nil, objects)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }

    static func post<T: JSONSerializable>(
        path: String,
        objectType: T.Type,
        parameters: Parameters,
        token: String?,
        encoding: URLEncoding = .default,
        completion: @escaping (Error?, T?) -> Void) {

        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }

        Alamofire.request(path, method: .post, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let responseJSON = JSON(value)
                let obj = T(json: responseJSON)
                completion(nil, obj)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }

    static func put(
        path: String,
        parameters: Parameters,
        token: String?,
        encoding: URLEncoding = .default,
        completion: @escaping (Error?) -> Void) {

        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }

        Alamofire.request(path, method: .put, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error)
            }
        }
    }

    static func patch(
        path: String,
        parameters: Parameters,
        token: String?,
        encoding: URLEncoding = .default,
        completion: @escaping (Error?) -> Void) {

        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }

        Alamofire.request(path, method: .patch, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error)
            }
        }
    }
        
    static func delete(
        path: String,
        token: String?,
        completion: @escaping (Error?) -> Void) {

        var headers: HTTPHeaders = [:]
        if let token = token {
            headers = [
                "Authorization": "Token \(token)",
            ]
        }

        Alamofire.request(path, method: .delete, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
