//
//  OnMapView.swift
//  Curbd
//
//  Created by Farbod Rafezy on 2/8/19.
//  Copyright © 2019 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit

/**
 UIView that has been subclassed to look good on
 top of a map
 */

class OnMapView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 3
    }
}
