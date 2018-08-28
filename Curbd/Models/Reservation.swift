//
//  Reservation.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/19/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Reservation {

    let id: Int
    let start: Date
    let end: Date
    let pricing: Int // cost every 5 minutes (in cents)
    let vehicle: Vehicle
    let parkingSpace: ParkingSpace
    let reserver: User
    let host: User
    var cost: Int
    let hostIncome: Int
    var pricePerHour: String {
        // price (in dollars) calculated per hour
        let pricePerHour = Double(pricing)/100.0
        let formattedPricePerHour = String(format: "%.02f", pricePerHour)
        return formattedPricePerHour
    }
    let paymentMethodInfo: String?
    let cancelled: Bool

    init(json: JSON) {
        self.id = json["id"].intValue
        self.start = Formatter.iso8601.date(from: json["start_datetime"].stringValue)!
        self.end = Formatter.iso8601.date(from: json["end_datetime"].stringValue)!
        self.vehicle = Vehicle(json: json["vehicle_detail"])
        self.parkingSpace = ParkingSpace(json: json["parking_space"])
        self.reserver = User(json: json["reserver"])
        self.host = User(json: json["host"])
        if let forRepeating = json["for_repeating"].bool {
            if forRepeating {
                self.pricing = json["repeating_availability"]["pricing"].intValue
            } else {
                self.pricing = json["fixed_availability"]["pricing"].intValue
            }
        } else {
            self.pricing = 0
        }
        self.cost = json["cost"].intValue
        self.hostIncome = json["host_income"].intValue
        self.paymentMethodInfo = json["payment_method_info"].string
        self.cancelled = json["cancelled"].boolValue
    }

    static func create(withToken token: String,
                       for parkingSpace: ParkingSpace,
                       withVehicle vehicleID: String,
                       from start: Date,
                       to end: Date,
                       cost: Int,
                       paymentMethodInfo: String,
                       completion: @escaping (Error?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        let parameters: Parameters = [
            "vehicle": vehicleID,
            "parking_space_id": parkingSpace.id,
            "start_datetime": Formatter.iso8601.string(from: start),
            "end_datetime": Formatter.iso8601.string(from: end),
            "cost": cost,
            "host_income": 0,
            "payment_method_info": paymentMethodInfo
        ]

        Alamofire.request(
            baseURL + "/api/parking/reservations/",
            method: .post,
            parameters: parameters,
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }

    func report(withToken token: String,
                title: String,
                comments: String?,
                hostIsReporting: Bool,
                completion: @escaping (Error?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        var parameters: Parameters = [
            "title": title,
            "reporter_type": hostIsReporting ? "host" : "customer"
        ]

        if let comments = comments {
            parameters["comments"] = comments
        }

        Alamofire.request(
            baseURL + "/api/parking/reservations/\(id)/report/",
            method: .post,
            parameters: parameters,
            headers: headers).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }

    }

    func cancel(withToken token: String, completion: @escaping (Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/parking/reservations/\(id)/cancel/",
            method: .post,
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
