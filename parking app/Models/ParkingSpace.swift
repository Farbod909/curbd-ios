//
//  ParkingSpace.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ParkingSpace {

    let id: Int
    let features: [String]
    let latitude: Double
    let longitude: Double
    let available_spaces: Int
    let size: Int
    let address: String
    let description: String
    let hostURL: String

    init(json: JSON) {
        self.id = json["id"].intValue
        self.features = json["features"].stringValue.components(separatedBy: ", ")
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.available_spaces = json["available_spaces"].intValue
        self.size = json["size"].intValue
        self.address = json["address"].stringValue
        self.description = json["description"].stringValue
        self.hostURL = json["host"].stringValue
    }

    func getPricing(from start: Date, to end: Date, completion: @escaping (Int?) -> Void) {

        let parameters: Parameters = [
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
        ]

        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/availability",
            parameters: parameters,
            encoding: URLEncoding.queryString).responseJSON { response in

                if let responseJSON = response.result.value {
                    let availabilityJSON = JSON(responseJSON)
                    completion(availabilityJSON["pricing"].int)
                } else {
                    completion(nil)
                }

        }
    }

    static func search(bl_lat: Double,
                       bl_long: Double,
                       tr_lat: Double,
                       tr_long: Double,
                       from start: Date,
                       to end: Date,
                       completion: @escaping ([ParkingSpace]?) -> Void) {

        let vehicleSize = UserDefaults.standard.integer(forKey: "vehicle_size")

        let parameters: Parameters = [
            "bl_lat": bl_lat,
            "bl_long": bl_long,
            "tr_lat": tr_lat,
            "tr_long": tr_long,
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
            "size": vehicleSize,
        ]

         Alamofire.request(
            baseURL + "/api/parking/spaces/",
            parameters: parameters,
            encoding: URLEncoding.queryString).responseJSON { response in

                if let responseJSON = response.result.value {
                    let parkingSpacesJSON = JSON(responseJSON)
                    let parkingSpaces: [ParkingSpace] =
                        parkingSpacesJSON["results"].arrayValue.map({ ParkingSpace(json: $0) })
                    completion(parkingSpaces)
                } else {
                    completion(nil)
                }

        }
    }

}
