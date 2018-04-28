//
//  File.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

let baseURL = "http://192.168.0.104:8000"
let baseCarQueryAPIURL = "https://www.carqueryapi.com/api/0.3"
let iphoneX = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
