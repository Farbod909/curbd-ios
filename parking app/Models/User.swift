//
//  User.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class User {

    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let isHost: Bool

    init(json: JSON) {
        self.id = json["id"].intValue
        self.email = json["email"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.phoneNumber = json["phone_number"].stringValue
        self.isHost = json["is_host"].boolValue
    }

    static func getToken(username: String,
                         password: String,
                         completion: @escaping (String?) -> Void) {

        let parameters: Parameters = [
            "username": username,
            "password": password,
        ]

        Alamofire.request(
            baseURL + "/api/auth/token",
            method: .post,
            parameters: parameters).responseJSON { response in
                if let responseJSON = response.result.value {
                    let tokenJSON = JSON(responseJSON)
                    completion(tokenJSON["token"].string)
                }
        }
    }

    static func getCurrentUserInfo(completion: @escaping (User?) -> Void) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            Alamofire.request(
                baseURL + "/api/accounts/users/self/",
                headers: headers).responseJSON() { response in
                    if let responseJSON = response.result.value {
                        let userJSON = JSON(responseJSON)
                        let user = User(json: userJSON)
                        completion(user)
                    } else {
                        completion(nil)
                    }
            }
        } else {
            completion(nil)
        }
    }

    static func getCurrentUserVehicles(completion: @escaping ([Vehicle]?) -> Void) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            Alamofire.request(
                baseURL + "/api/accounts/users/self/customer/",
                headers: headers).responseJSON() { response in
                    if let responseJSON = response.result.value {
                        let customerJSON = JSON(responseJSON)
                        let vehicles = customerJSON["car_set"].arrayValue.map() { Vehicle(json: $0) }
                        completion(vehicles)
                    } else {
                        completion(nil)
                    }
            }
        }
    }

}
