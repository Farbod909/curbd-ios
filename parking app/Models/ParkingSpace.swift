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
    let name: String
    let instructions: String
    let physical_type: String
    let legal_type: String
    let is_active: Bool

    init(json: JSON) {
        self.id = json["id"].intValue
        self.features = json["features"].stringValue.components(separatedBy: ", ")
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.available_spaces = json["available_spaces"].intValue
        self.size = json["size"].intValue
        self.name = json["name"].stringValue
        self.instructions = json["instructions"].stringValue
        self.physical_type = json["physical_type"].stringValue
        self.legal_type = json["legal_type"].stringValue
        self.is_active = json["is_active"].boolValue
    }

    static func create(latitude: Double,
                       longitude: Double,
                       available_spaces: Int,
                       features: [String],
                       physical_type: String,
                       legal_type: String,
                       name: String,
                       size: Int) {
        
    }

    func getPricing(from start: Date, to end: Date, completion: @escaping (Int?) -> Void) {

        let parameters: Parameters = [
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
        ]

        Alamofire.request(
            baseURL + "/api/parking/spaces/\(id)/availability", //TODO: avoid forceful unwrap
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

    func getRepeatingAvailabilities(withToken token: String,
                                    completion: @escaping (Error?, [RepeatingAvailability]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]
        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/repeatingavailabilities/",
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let repeatingAvailabilitiesJSON = JSON(value)
                    let repeatingAvailabilities: [RepeatingAvailability] = repeatingAvailabilitiesJSON["results"].arrayValue.map({ RepeatingAvailability(json: $0) })
                    completion(nil, repeatingAvailabilities)
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    func getFixedAvailabilities(withToken token: String,
                                    completion: @escaping (Error?, [FixedAvailability]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]
        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/fixedavailabilities/",
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let fixedAvailabilitiesJSON = JSON(value)
                    let fixedAvailabilities: [FixedAvailability] = fixedAvailabilitiesJSON["results"].arrayValue.map({ FixedAvailability(json: $0) })
                    completion(nil, fixedAvailabilities)
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    func getCurrentReservations(withToken token: String,
                                completion: @escaping (Error?, [Reservation]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]
        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/reservations/current/",
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let reservationsJSON = JSON(value)
                    let reservations: [Reservation] = reservationsJSON["results"].arrayValue.map({ Reservation(json: $0) })
                    completion(nil, reservations)
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    func getPreviousReservations(withToken token: String,
                                completion: @escaping (Error?, [Reservation]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]
        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/reservations/previous/",
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let reservationsJSON = JSON(value)
                    let reservations: [Reservation] = reservationsJSON["results"].arrayValue.map({ Reservation(json: $0) })
                    completion(nil, reservations)
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

}
