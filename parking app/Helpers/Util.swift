//
//  File.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation

func humanReadableDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a, MMM d"

    return dateFormatter.string(from: date)
}

func toISOString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DDTHH:mm:'00'Z"

    return dateFormatter.string(from: date)
}
