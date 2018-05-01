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

    static func create(firstName: String,
                       lastName: String,
                       email: String,
                       phone: String,
                       password: String,
                       completion: @escaping (Error?, User?) -> Void) {

        let parameters: Parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone_number": phone,
            "password": password,
        ]

        Alamofire.request(
            baseURL + "/api/accounts/users/",
            method: .post,
            parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let user = User(json: JSON(value))
                    completion(nil, user)

                case .failure(let error):
                    if let validationError = ValidationError(from: error, with: response.data) {
                        completion(validationError, nil)
                    } else {
                        completion(error, nil)
                    }
                }
        }
    }

    static func login(username: String,
                      password: String,
                      completion: @escaping (Error?) -> Void) {

        self.getToken(username: username, password: password) { error, token in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "token")

                User.getDetail(token: token) { error, user in
                    if let user = user {
                        // TODO: possibly encode an entire User object into UserDefaults
                        user.saveToUserDefaults()
                    } else {
                        completion(error)
                    }
                }

                User.getCustomerVehicles(token: token) { error, vehicles in
                    if let vehicles = vehicles {
                        if let firstVehicle = vehicles.first {
                            firstVehicle.setAsCurrentVehicle()
                        }
                        // complete with no errors only after receiving
                        // user vehicle information.
                        completion(nil)

                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error)
            }
        }

    }

    static func logout(completion: @escaping () -> Void) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_firstname")
        UserDefaults.standard.removeObject(forKey: "user_lastname")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_is_host")

        Vehicle.unsetCurrentVehicle()

        completion()
    }

    static func getToken(username: String,
                         password: String,
                         completion: @escaping (Error?, String?) -> Void) {

        let parameters: Parameters = [
            "username": username,
            "password": password,
        ]

        Alamofire.request(
            baseURL + "/api/auth/token",
            method: .post,
            parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let tokenJSON = JSON(value)
                    completion(nil, tokenJSON["token"].string)

                case .failure(let error):
                    if let validationError = ValidationError(from: error, with: response.data) {
                        completion(validationError, nil)
                    } else {
                        completion(error, nil)
                    }
                }
        }
    }

    static func getDetail(token: String, completion: @escaping (Error?, User?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/accounts/users/self/",
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success(let value):
                    let userJSON = JSON(value)
                    let user = User(json: userJSON)
                    completion(nil, user)

                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    static func getCustomerVehicles(token: String,
                                    completion: @escaping (Error?, [Vehicle]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/accounts/customers/self/",
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success(let value):
                    let customerJSON = JSON(value)
                    let vehicles = customerJSON["car_set"].arrayValue.map() { Vehicle(json: $0) }
                    completion(nil, vehicles)
                    
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    func saveToUserDefaults() {
        UserDefaults.standard.set(self.id, forKey: "user_id")
        UserDefaults.standard.set(self.firstName, forKey: "user_firstname")
        UserDefaults.standard.set(self.lastName, forKey: "user_lastname")
        UserDefaults.standard.set(self.email, forKey: "user_email")
        UserDefaults.standard.set(self.isHost, forKey: "user_is_host")
    }

}
