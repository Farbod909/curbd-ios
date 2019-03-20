//
//  JSONSerializable.swift
//  Curbd
//
//  Created by Ryan Dang on 3/19/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONSerializable {
    init(json: JSON)
}
