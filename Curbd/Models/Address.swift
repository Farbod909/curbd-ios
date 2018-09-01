//
//  Address.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/10/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Address {
    let address1: String
    let address2: String?
    let city: String
    let state: String
    let code: String

    init(json: JSON) {
        self.address1 = json["address1"].stringValue
        self.address2 = json["address2"].string
        self.city = json["city"].stringValue
        self.state = json["state"].stringValue
        self.code = json["code"].stringValue
    }

}
