//
//  ParkingSpace.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//
import Alamofire
import Foundation
import SwiftyJSON


class ParkingSpace {

    static let vehicleSize = [
        1: "Motorcycle",
        2: "Compact",
        3: "Mid-sized",
        4: "Large",
        5: "Oversized",
    ]

    let features: [String]
    let latitude: Double
    let longitude: Double
    let available_spaces: Int
    let size: Int
    let address: String
    let description: String
    let hostURL: String

    init(features: [String], latitude: Double, longitude: Double, available_spaces: Int, size: Int, address: String, description: String, hostURL: String) {
        self.features = features
        self.latitude = latitude
        self.longitude = longitude
        self.available_spaces = available_spaces
        self.size = size
        self.address = address
        self.description = description
        self.hostURL = hostURL
    }

    init(json: JSON) {
        self.features = json["features"].stringValue.components(separatedBy: ", ")
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.available_spaces = json["available_spaces"].intValue
        self.size = json["size"].intValue
        self.address = json["address"].stringValue
        self.description = json["description"].stringValue
        self.hostURL = json["host"].stringValue
    }

    static func search(bl_lat: Double, bl_long: Double, tr_lat: Double, tr_long: Double, from start: Date, to end: Date, completion: @escaping ([ParkingSpace]) -> Void) {

        let parameters: Parameters = [
            "bl_lat": bl_lat,
            "bl_long": bl_long,
            "tr_lat": tr_lat,
            "tr_long": tr_long,
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
        ]

         Alamofire.request(
            baseURL + "/api/parking/spaces",
            parameters: parameters,
            encoding: URLEncoding.queryString).responseJSON { response in
                let parkingSpacesJSON = JSON(response.result.value!)

                var parkingSpaces = [ParkingSpace]()
                for (_, json):(String, JSON) in parkingSpacesJSON["results"] {
                    parkingSpaces.append(ParkingSpace(json: json))
                }
                completion(parkingSpaces)
         }
    }
}
