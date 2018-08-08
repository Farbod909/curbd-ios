//
//  HostInfoGatherViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/5/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation

class HostInfoGatherViewController: FormViewController {

    var hostInfo: HostInfo?
    var payoutAmount: Int? // in US cents

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClick(_:)))
        navigationItem.title = "Host Information"
        initializeForm()

    }

    func initializeForm() {
        form
            +++ Section("Address")
            <<< NameRow("street address") {
                $0.placeholder = $0.tag?.capitalized
            }

            <<< ZipCodeRow("zip code") {
                $0.placeholder = $0.tag?.capitalized
                }.onChange() { zipCodeRow in
                    if let zipCode = zipCodeRow.value, zipCode.count >= 5 {
                        if  let cityRow = self.form.rowBy(tag: "city") as? NameRow,
                            let stateRow = self.form.rowBy(tag: "state") as? TextRow {
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(zipCode) { placemarks, error in
                                if(error != nil) {
                                    print("Error", error ?? "")
                                }
                                if let placemark = placemarks?.first {
                                    cityRow.value = placemark.locality
                                    stateRow.value = placemark.administrativeArea
                                }
                            }

                        }
                    }
            }

            <<< NameRow("city") {
                $0.placeholder = $0.tag?.capitalized
            }

            <<< TextRow("state") {
                $0.placeholder = $0.tag?.capitalized
            }

            +++ DateInlineRow("date of birth") {
                $0.title = "Date of Birth"
            }


    }

    @objc func nextButtonClick(_ sender: UIBarButtonItem) {
        let venmoPayoutViewController = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(withIdentifier: "venmoPayoutViewController") as! VenmoPayoutViewController

        venmoPayoutViewController.venmoEmail = hostInfo?.venmoEmail
        venmoPayoutViewController.venmoPhone = hostInfo?.venmoPhone
        venmoPayoutViewController.payoutAmount = payoutAmount
        
        show(venmoPayoutViewController, sender: self)

    }
}
