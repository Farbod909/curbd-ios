//
//  Reservation.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/19/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Reservation {

    static func create(for parkingSpace: ParkingSpace,
                       from start: Date,
                       to end: Date,
                       completion: @escaping () -> Void) {
        if  let currentVehicleID = UserDefaults.standard.string(forKey: "vehicle_id"),
            let token = UserDefaults.standard.string(forKey: "token") {

            print("create called")

            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            let parameters: Parameters = [
                "car": currentVehicleID,
                "parking_space": parkingSpace.id,
                "start_datetime": Formatter.iso8601.string(from: start),
                "end_datetime": Formatter.iso8601.string(from: end),
            ]

            Alamofire.request(
                baseURL + "/api/parking/reservations/",
                method: .post,
                parameters: parameters,
                headers: headers).response { response in
                    completion()
            }
        }
    }

}
