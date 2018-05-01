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
                       completion: @escaping (String, String) -> Void) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            if let currentVehicleID = UserDefaults.standard.string(forKey: "vehicle_id") {
                let headers: HTTPHeaders = [
                    "Authorization": "Token \(token)",
                ]

                let parameters: Parameters = [
                    "car_id": currentVehicleID,
                    "parking_space_id": parkingSpace.id,
                    "start_datetime": Formatter.iso8601.string(from: start),
                    "end_datetime": Formatter.iso8601.string(from: end),
                ]

                Alamofire.request(
                    baseURL + "/api/parking/reservations/",
                    method: .post,
                    parameters: parameters,
                    headers: headers).response { response in
                        if response.response?.statusCode == 201 {
                            completion(
                                "Successfully Reserved",
                                "You successfully reserved this parking space!")
                        } else {
                            completion(
                                "Something Went Wrong",
                                "Oops, looks like something went wrong.")
                        }
                }
            } else {
                completion(
                    "Add a Vehicle First",
                    "You need to add a vehicle before you can reserve a spot.")
            }
        } else {
            completion(
                "Not Authenticated",
                "Looks like you're not logged in. Try logging in first.")
        }
    }

}
