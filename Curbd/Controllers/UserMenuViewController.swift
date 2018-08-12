//
//  UserMenuViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/15/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class UserMenuViewController: DarkTranslucentViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var hostASpaceButton: UIButton!
    @IBOutlet weak var hostDashboardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let firstName = UserDefaults.standard.string(forKey: "user_firstname") {
            firstNameLabel.text = firstName.capitalized
        }

        let isHost = UserDefaults.standard.bool(forKey: "user_is_host")
        if isHost {
            hostDashboardButton.isHidden = false
        } else {
            hostASpaceButton.isHidden = false
        }

    }

    @IBAction func paymentButtonClick(_ sender: UIButton) {
        let customerContext = STPCustomerContext(keyProvider: PaymentClient.sharedClient)

        // Setup payment methods view controller
        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)

        // Present payment methods view controller
        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
        present(navigationController, animated: true)
    }

    @IBAction func closeButtonClick(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMapViewController", sender: self)
    }

    @IBAction func unwindToUserMenuViewController(segue:UIStoryboardSegue) {
        UserDefaults.standard.set(true, forKey: "user_is_host")
        hostDashboardButton.isHidden = false
        hostASpaceButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hostDashboardButton.blink()
        }
    }
    
}

extension UserMenuViewController: STPPaymentMethodsViewControllerDelegate {
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true)
    }

    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true)
    }

    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true)
    }

}
