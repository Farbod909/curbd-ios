//
//  AppDelegate.swift
//  Curbd
//
//  Created by Farbod Rafezy on 9/11/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import Stripe
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()

        Siren.shared.wail()
        STPTheme.default().accentColor = UIColor.curbdPurpleBright

        // TODO: change to stripe live publishable key
        STPPaymentConfiguration.shared().publishableKey = "pk_test_5q5DlFsEzct0uumMRvd37mln"

        let locationManager = LocationManager.shared
        locationManager.requestWhenInUseAuthorization()
        
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let params = components.queryItems else {
                return false
        }

        if let passwordResetToken = params.first(where: { $0.name == "token" } )?.value {

            // set mainVC as the root view controller then add login view controller and
            // new password view controller on to the view controller hierarchy so that
            // when a user dismisses the new password view controller, the login view controller
            // is shown.

            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as UIViewController
            let newPasswordViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordViewController") as! NewPasswordViewController
            newPasswordViewController.passwordResetToken = passwordResetToken
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

            window?.rootViewController = mainVC
            mainVC.present(loginViewController, animated: false)
            loginViewController.present(newPasswordViewController, animated: false)

            window?.makeKeyAndVisible()
            return true
        } else {
            print("Token is missing")
            return false
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

