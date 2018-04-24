//
//  Errors.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/24/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation

struct ValidationError: Error {

    var fields: [String: String]

}
