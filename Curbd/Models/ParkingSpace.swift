//
//  ParkingSpace.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreLocation

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
    let images: [String]
    let is_active: Bool

    init(json: JSON) {
        self.id = json["id"].intValue
        if json["features"].stringValue != "" {
            self.features = json["features"].stringValue.components(separatedBy: ", ")
        } else {
            self.features = []
        }
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.available_spaces = json["available_spaces"].intValue
        self.size = json["size"].intValue
        self.name = json["name"].stringValue
        self.instructions = json["instructions"].stringValue
        self.physical_type = json["physical_type"].stringValue
        self.legal_type = json["legal_type"].stringValue
        self.images = json["images"].arrayValue.map({$0.stringValue})
        self.is_active = json["is_active"].boolValue
    }

    static func create(withToken token: String,
                       address1: String,
                       address2: String?,
                       city: String,
                       state: String,
                       code: String,
                       available_spaces: Int,
                       features: Set<String>?,
                       physical_type: String,
                       legal_type: String,
                       name: String,
                       instructions: String,
                       sizeDescription: String,
                       images: [UIImage] = [],
                       is_active: Bool = false,
                       completion: @escaping (Error?, ParkingSpace?) -> Void) {

        let addressString =
            [address1, city, state].joined(separator: ", ") + " \(code)"

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                // no location found
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            var parameters: Parameters = [
                "address1": address1,
                "city": city,
                "state": state,
                "code": code,

                // round latitude and longitude to 6 decimal places
                "latitude": Double(round(1000000*location.coordinate.latitude)/1000000),
                "longitude": Double(round(1000000*location.coordinate.longitude)/1000000),

                "available_spaces": available_spaces,
                "size": Vehicle.sizes[sizeDescription] ?? 2, // 2 is Mid-sized
                "name": name,
                "instructions": instructions,
                "physical_type": physical_type,
                "legal_type": legal_type,
                "is_active": is_active,
            ]

            if let address2 = address2 {
                parameters["address2"] = address2
            }

            if let features = features {
                parameters["features"] = features.joined(separator: ", ")
            }

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

                for image in images {
                    let imageData = UIImageJPEGRepresentation(image, 0.5)
                    if let imageData = imageData {
                        let fileFriendlyName = name.components(
                            separatedBy: .punctuationCharacters).joined().replacingOccurrences(
                                of: " ",
                                with: "-") + "-\(String.random(length: 8))"
                        multipartFormData.append(
                            imageData,
                            withName: "images",
                            fileName: "\(fileFriendlyName).jpg",
                            mimeType: "image/jpeg")
                    }
                }

            }, usingThreshold: UInt64.init(),
               to: baseURL + "/api/parking/spaces/",
               method: .post,
               headers: headers) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.validate().responseJSON() { response in
                        switch response.result {
                        case .success(let value):
                            let parkingSpace = ParkingSpace(json: JSON(value))
                            completion(nil, parkingSpace)

                        case .failure(let error):
                            if let validationError = ValidationError(from: error, with: response.data) {
                                completion(validationError, nil)
                            } else {
                                completion(error, nil)
                            }
                        }
                    }
                case .failure(let error):
                    completion(error, nil)
                }
            }


//            Alamofire.request(
//                baseURL + "/api/parking/spaces/",
//                method: .post,
//                parameters: parameters,
//                headers: headers).validate().responseJSON { response in
//                    switch response.result {
//                    case .success(let value):
//                        let parkingSpace = ParkingSpace(json: JSON(value))
//                        completion(nil, parkingSpace)
//
//                    case .failure(let error):
//                        if let validationError = ValidationError(from: error, with: response.data) {
//                            completion(validationError, nil)
//                        } else {
//                            completion(error, nil)
//                        }
//                    }
//            }

        }
        
    }

    func patch(withToken token: String,
               parameters: Parameters,
               completion: @escaping (Error?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/",
            method: .patch,
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

    func delete(withToken token: String, completion: @escaping (Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/",
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

    func getPricing(from start: Date, to end: Date, completion: @escaping (Int?) -> Void) {

        let parameters: Parameters = [
            "start": Formatter.iso8601.string(from: start),
            "end": Formatter.iso8601.string(from: end),
        ]

        Alamofire.request(
            baseURL + "/api/parking/spaces/\(id)/availability/",
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
                       completion: @escaping ([ParkingSpaceWithPrice]?) -> Void) {

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
            baseURL + "/api/parking/spaces/search/",
            parameters: parameters,
            encoding: URLEncoding.queryString).responseJSON { response in

                if let responseJSON = response.result.value {
                    let parkingSpacesJSON = JSON(responseJSON)
                    let parkingSpaces: [ParkingSpaceWithPrice] =
                        parkingSpacesJSON["results"].arrayValue.map({ ParkingSpaceWithPrice(json: $0) })
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

    func getFutureFixedAvailabilities(withToken token: String,
                                    completion: @escaping (Error?, [FixedAvailability]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]
        Alamofire.request(
            baseURL + "/api/parking/spaces/\(self.id)/fixedavailabilities/future/",
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
