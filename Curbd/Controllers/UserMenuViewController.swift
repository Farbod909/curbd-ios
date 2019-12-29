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

    func initializeAppearanceSettings() {
        firstNameLabel.textColor = UIColor.curbdPurpleBright
        hostASpaceButton.backgroundColor = UIColor.curbdPurpleGradient(frame: hostASpaceButton.frame)
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeAppearanceSettings()
    }

    @IBAction func paymentButtonClick(_ sender: UIButton) {
        let customerContext = STPCustomerContext(keyProvider: PaymentClient.sharedClient)

        let curbdTheme = STPTheme()
        curbdTheme.accentColor = UIColor.white
        curbdTheme.secondaryBackgroundColor = UIColor.curbdPurpleBright.adjustedForPaymentsNavigationController
        curbdTheme.secondaryForegroundColor = UIColor.white
        curbdTheme.primaryBackgroundColor = UIColor.curbdPurpleBright
        curbdTheme.primaryForegroundColor = UIColor.white

        // Setup payment methods view controller
        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)

        // Present payment methods view controller
        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)

        navigationController.navigationBar.stp_theme = curbdTheme

        print("hello")

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
    }

    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true)
    }

}
