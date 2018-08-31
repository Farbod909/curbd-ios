//
//  LoadingView.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/29/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol LoadingViewProtocol {
    var loadingView: LoadingView { get set }
    func startLoading()
    func stopLoading()
}

class LoadingView: UIView {
    static let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
    var activityIndicator: NVActivityIndicatorView

    init() {
        self.activityIndicator = NVActivityIndicatorView(frame: LoadingView.rect, type: defaultLoadingStyle, color: .gray, padding: 10)

        super.init(frame: LoadingView.rect)

        self.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
        self.layer.shadowPath = UIBezierPath(
            rect: self.bounds).cgPath
        self.addSubview(activityIndicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        activityIndicator.startAnimating()
    }

    func stop() {
        activityIndicator.stopAnimating()
    }
}
