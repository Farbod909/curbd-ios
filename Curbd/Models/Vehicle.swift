//
//  Vehicle.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Vehicle: JSONSerializable {

    static let sizeDescriptions = [
        1: "Motorcycle",
        2: "Compact",
        3: "Mid-sized",
        4: "Large",
        5: "Oversized",
    ]

    static let sizes = [
        "Motorcycle": 1,
        "Compact": 2,
        "Mid-sized": 3,
        "Large": 4,
        "Oversized": 5,
    ]

    let id: Int
    let year: Int
    let make: String
    let model: String
    let color: String
    let size: Int
    let licensePlate: String
    var sizeDescription: String {
        if let sizeDescription = Vehicle.sizeDescriptions[size] {
            return sizeDescription
        } else {
            return "N/A Size"
        }
    }

    required init(json: JSON) {
        self.id = json["id"].intValue
        self.year = json["year"].intValue
        self.make = json["make"].stringValue
        self.model = json["model"].stringValue
        self.color = json["color"].stringValue
        self.size = json["size"].intValue
        self.licensePlate = json["license_plate"].stringValue
    }

    static func create(withToken token: String,
                       year: Int,
                       make: String,
                       model: String,
                       color: String,
                       size: Int,
                       licensePlate: String,
                       completion: @escaping (Error?, Vehicle?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        let parameters: Parameters = [
            "year": year,
            "make": make,
            "model": model,
            "color": color,
            "size": size,
            "license_plate": licensePlate
        ]

        Alamofire.request(
            baseURL + "/api/accounts/vehicles/",
            method: .post,
            parameters: parameters,
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let vehicle = Vehicle(json: JSON(value))
                    completion(nil, vehicle)

                case .failure(let error):
                    if let validationError = ValidationError(from: error, with: response.data) {
                        completion(validationError, nil)
                    } else {
                        completion(error, nil)
                    }
                }
        }
    }

    func delete(withToken token: String, completion: @escaping (Error?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/accounts/vehicles/\(self.id)/",
            method: .delete,
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success:
                    completion(nil)

                case .failure(let error):
                    completion(error)
                }
        }
    }

    static func currentVehicleIsSet() -> Bool {
        return UserDefaults.standard.string(forKey: "vehicle_license_plate") != nil
    }
    
    func isCurrentVehicle() -> Bool {
        return UserDefaults.standard.integer(forKey: "vehicle_id") == id
    }

    func setAsCurrentVehicle() {
        UserDefaults.standard.set(self.licensePlate, forKey: "vehicle_license_plate")
        UserDefaults.standard.set(self.id, forKey: "vehicle_id")
        UserDefaults.standard.set(self.size, forKey: "vehicle_size")
    }

    static func unsetCurrentVehicle() {
        UserDefaults.standard.removeObject(forKey: "vehicle_license_plate")
        UserDefaults.standard.removeObject(forKey: "vehicle_id")
        UserDefaults.standard.removeObject(forKey: "vehicle_size")
    }
    
}
