//
//  FixedAvailability.swift
//  Curbd
//
//  Created by Farbod Rafezy on 7/4/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FixedAvailability: JSONSerializable {

    let id: Int
    let parking_space: Int
    let start_datetime: Date
    let end_datetime: Date
    let pricing: Int
    var formattedHourlyPrice: String {
        // price (in dollars) calculated per hour
        let pricePerHour = Double(pricing)/100.0
        let formattedPricePerHour = String(format: "$%.02f / hr", pricePerHour)
        return formattedPricePerHour
    }


    required init(json: JSON) {
        self.id = json["id"].intValue
        self.parking_space = json["parking_space"].intValue
        self.start_datetime = Formatter.iso8601.date(from: json["start_datetime"].stringValue)!
        self.end_datetime = Formatter.iso8601.date(from: json["end_datetime"].stringValue)!
        self.pricing = json["pricing"].intValue
    }

    static func create(withToken token: String,
                       parkingSpace: ParkingSpace,
                       start: Date,
                       end: Date,
                       pricing: Int,
                       completion: @escaping (Error?, FixedAvailability?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        let parameters: Parameters = [
            "parking_space": parkingSpace.id,
            "start_datetime": Formatter.iso8601.string(from: start),
            "end_datetime": Formatter.iso8601.string(from: end),
            "pricing": pricing,
        ]

        Alamofire.request(
            baseURL + "/api/parking/fixedavailabilities/",
            method: .post,
            parameters: parameters,
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success(let value):
                    let fixedAvailability = FixedAvailability(json: JSON(value))
                    completion(nil, fixedAvailability)

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
            baseURL + "/api/parking/fixedavailabilities/\(self.id)/",
            method: .delete,
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }

}
