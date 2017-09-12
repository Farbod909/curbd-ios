//
//  DrawerViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 9/12/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import Pulley

class DrawerViewController: UIViewController, UITextFieldDelegate, PulleyDrawerViewControllerDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var grabber: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.backgroundColor = UIColor.clear.withAlphaComponent(0.08)
        searchField.layer.cornerRadius = 8
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 0
        let searchFieldPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: self.searchField.frame.height))
        searchField.leftView = searchFieldPaddingView
        searchField.leftViewMode = UITextFieldViewMode.always

        searchField.delegate = self

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open, .partiallyRevealed, .collapsed]
    }

    func partialRevealDrawerHeight() -> CGFloat {
        return 68
    }

    func collapsedDrawerHeight() -> CGFloat {
        return 264
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition != .open {
            searchField.resignFirstResponder()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .open)
        }
    }
}
