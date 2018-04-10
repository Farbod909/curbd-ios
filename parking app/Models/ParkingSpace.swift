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

    static func findSpaces(bl_lat: Double, bl_long: Double, tr_lat: Double, tr_long: Double, from start: Date, to end: Date) {//, completionHandler: @escaping ([ParkingSpace]) -> Void) {

        let parameters: Parameters = [
            "bl_lat": bl_lat,
            "bl_long": bl_long,
            "tr_lat": tr_lat,
            "tr_long": tr_long,
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
        ]

         Alamofire.request(
            "http://localhost:8000/api/parking/spaces",
            parameters: parameters,
            encoding: URLEncoding.queryString).responseJSON { response in
                let parkingSpacesJSON = JSON(response.result.value!)
                print(parkingSpacesJSON)
         }
    }
}
