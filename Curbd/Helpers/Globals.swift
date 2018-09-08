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

let baseURL = "http://192.168.1.8:8000"
//let baseURL = "https://curbd-app.appspot.com"
let defaultLoadingStyle = NVActivityIndicatorType.circleStrokeSpin
let iphoneX = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
