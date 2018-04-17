//
//  User.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class User {

    static func getToken(username: String,
                         password: String,
                         completion: @escaping (String?) -> Void) {

        let parameters: Parameters = [
            "username": username,
            "password": password,
        ]

        Alamofire.request(
            baseURL + "/api/auth/token",
            method: .post,
            parameters: parameters).responseJSON { response in
                if let responseJSON = response.result.value {
                    let tokenJSON = JSON(responseJSON)
                    completion(tokenJSON["token"].string)
                }
        }
    }

}
