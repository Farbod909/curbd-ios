//
//  LoadingView.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/29/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    static let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
    var activityIndicator: UIActivityIndicatorView

    init() {
        self.activityIndicator = UIActivityIndicatorView(frame: LoadingView.rect)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray

        super.init(frame: LoadingView.rect)

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
        self.layer.shadowPath = UIBezierPath(
            rect: self.bounds).cgPath
        self.addSubview(activityIndicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
