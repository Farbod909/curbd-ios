//
//  Errors.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/24/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct ValidationError: Error {

    var fields: [String: String]

    init?(from error: Error, with data: Data?) {
        if let error = error as? Alamofire.AFError {
            if error.isResponseValidationError {

                if let data = data {
                    if let responseJSON = try? JSON(data: data) {
                        fields = [:]
                        for (field, messageList):(String, JSON) in responseJSON {
                            fields[field] = String(describing: messageList.arrayValue[0])
                        }
                        return
                    }
                }

            }
        }
        return nil
    }

}
