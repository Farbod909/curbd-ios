//
//  EmptyTableView.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/31/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit

class EmptyTableView: UIView {

    init(frame: CGRect, message: String? = nil) {

        super.init(frame: frame)

        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        if let message = message {
            messageLabel.text = message
        } else {
            messageLabel.text = "Nothing here yet"
        }
        messageLabel.font = messageLabel.font.withSize(20)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.center = self.center

        self.addSubview(messageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
