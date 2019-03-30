//
//  Globals.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let baseURL = "http://172.31.99.23:8000"
//let baseURL = "https://curbd-app.appspot.com"
let defaultLoadingStyle = NVActivityIndicatorType.circleStrokeSpin
let iphoneX = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
