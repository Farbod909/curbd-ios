//
//  Vehicle.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/17/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Vehicle {

    static let sizes = [
        1: "Motorcycle",
        2: "Compact",
        3: "Mid-sized",
        4: "Large",
        5: "Oversized",
    ]

    let id: Int
    let year: Int
    let make: String
    let model: String
    let color: String
    let size: Int
    let licensePlate: String
    var sizeString: String {
        if let sizeString = Vehicle.sizes[size] {
            return sizeString
        } else {
            return "N/A Size"
        }
    }

    init(json: JSON) {
        self.id = json["id"].intValue
        self.year = json["year"].intValue
        self.make = json["make"].stringValue
        self.model = json["model"].stringValue
        self.color = json["color"].stringValue
        self.size = json["size"].intValue
        self.licensePlate = json["license_plate"].stringValue
    }

    static func create(token: String,
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
            baseURL + "/api/accounts/cars/",
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

    func saveToUserDefaults() {
        UserDefaults.standard.set(self.licensePlate, forKey: "vehicle_license_plate")
        UserDefaults.standard.set(self.id, forKey: "vehicle_id")
        UserDefaults.standard.set(self.size, forKey: "vehicle_size")
    }
    
}
