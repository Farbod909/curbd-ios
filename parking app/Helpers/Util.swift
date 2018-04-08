//
//  File.swift
//  parking app
//
//  Created by Farbod Rafezy on 4/8/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation

func humanReadableDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

    let dateObj = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "h:mm a, MMM d"

    return dateFormatter.string(from: dateObj!)
}
