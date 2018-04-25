//
//  Errors.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/24/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct ValidationError: Error {

    var fields: [String: String]

    init(json: JSON) {
        fields = [:]
        for (field, messageList):(String, JSON) in json {
            fields[field] = String(describing: messageList.arrayValue[0])
        }
    }

    static func getFrom(error: Error, with data: Data?) -> ValidationError? {
        if let error = error as? Alamofire.AFError {
            if error.isResponseValidationError {

                if let data = data {
                    let responseJSON = JSON(data: data)
                    return ValidationError(json: responseJSON)
                }

            }
        }
        return nil
    }

}
