//
//  DarkTranslucentViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/23/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class DarkTranslucentViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.insertSubview(blurEffectView, at: 0)

        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
