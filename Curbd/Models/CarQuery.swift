//
//  CarQuery.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CarQuery {
    static let url = "https://www.carqueryapi.com/api/0.3/"

    static func getYears(completion: @escaping (Error?, CountableClosedRange<Int>?) -> Void) {
        let parameters: Parameters = [
            "cmd": "getYears"
        ]
        Alamofire.request(url, parameters: parameters).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let fromYear = json["Years"]["min_year"].intValue
                let toYear = json["Years"]["max_year"].intValue
                completion(nil, fromYear...toYear)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }

    static func getMakes(year: Int, completion: @escaping (Error?, [String]?) -> Void) {
        let parameters: Parameters = [
            "cmd": "getMakes",
            "year": year
        ]
        Alamofire.request(url, parameters: parameters).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let makes = json["Makes"].arrayValue.map() {
                    return $0["make_display"].stringValue
                }
                completion(nil, makes)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }

    static func getModels(make: String,
                          year: Int,
                          completion: @escaping (Error?, [String]?) -> Void) {
        let parameters: Parameters = [
            "cmd": "getModels",
            "make": make,
            "year": year
        ]
        Alamofire.request(url, parameters: parameters).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let models = json["Models"].arrayValue.map() {
                    return $0["model_name"].stringValue
                }
                completion(nil, models)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}
