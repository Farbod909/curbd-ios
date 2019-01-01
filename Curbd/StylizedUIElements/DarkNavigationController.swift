//
//  DarkNavigationController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/30/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class DarkNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.curbdPurpleBright
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBar.barStyle = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.barTintColor = UIColor.curbdPurpleBright
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
}
