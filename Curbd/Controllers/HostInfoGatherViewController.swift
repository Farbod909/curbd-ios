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
            <<< NameRow("address1") {
                $0.placeholder = "Street address"
            }
            <<< NameRow("address2") {
                $0.placeholder = "Apartment, suite, floor #, etc."
            }
            <<< ZipCodeRow("code") {
                $0.placeholder = "Zip code"
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

        let address1Field = form.rowBy(tag: "address1") as! NameRow
        let address2Field = form.rowBy(tag: "address2") as! NameRow
        let codeField = form.rowBy(tag: "code") as! ZipCodeRow
        let cityField = form.rowBy(tag: "city") as! NameRow
        let stateField = form.rowBy(tag: "state") as! TextRow
        let dateOfBirthField = form.rowBy(tag: "date of birth") as! DateInlineRow

        if let token = UserDefaults.standard.string(forKey: "token") {
            if  let address1 = address1Field.value,
                let city = cityField.value,
                let state = stateField.value,
                let code = codeField.value,
                let dateOfBirth = dateOfBirthField.value?.dateComponentAsParseableString() {

                User.updateHostVerificationInfo(
                    withToken: token,
                    address1: address1,
                    address2: address2Field.value,
                    city: city,
                    state: state,
                    code: code,
                    dateOfBirth: dateOfBirth) { error in

                        if error == nil {
                            let venmoPayoutViewController = UIStoryboard(
                                name: "Main",
                                bundle: nil).instantiateViewController(withIdentifier: "venmoPayoutViewController") as! VenmoPayoutViewController

                            venmoPayoutViewController.venmoEmail = self.hostInfo?.venmoEmail
                            venmoPayoutViewController.venmoPhone = self.hostInfo?.venmoPhone
                            venmoPayoutViewController.payoutAmount = self.payoutAmount

                            self.show(venmoPayoutViewController, sender: self)
                        } else {
                            self.presentServerErrorAlert()
                        }

                }

            } else {
                self.presentSingleButtonAlert(
                    title: "Incomplete Fields",
                    message: "Please complete all required fields and try again.")
            }
            
        }


    }
}
