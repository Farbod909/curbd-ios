//
//  AddParkingSpaceViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 7/3/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import UIKit
import Eureka
import MapKit

class AddParkingSpaceViewController: FormViewController {

    func initializeSettings() {
        animateScroll = true

//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Next", style: .plain, target: self, action: #selector(nextButtonClick))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        form
            +++ Section("Details")
            <<< NameRow("street address") {
                $0.placeholder = $0.tag?.capitalized
            }

            <<< TextRow("unit number") {
                $0.placeholder = "Unit #"
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
//                $0.disabled = Condition.function(["zip code"], { form in
//                    if let zipCodeRow = form.rowBy(tag: "zip code") as? ZipCodeRow {
//                        return zipCodeRow.value == nil
//                    }
//                    return true
//                })
            }

            <<< TextRow("state") {
                $0.placeholder = $0.tag?.capitalized
//                $0.disabled = Condition.function(["zip code"], { form in
//                    if let zipCodeRow = form.rowBy(tag: "zip code") as? ZipCodeRow {
//                        return zipCodeRow.value == nil
//                    }
//                    return true
//                })
            }

            +++ IntRow("available spots") {
                $0.title = $0.tag?.capitalized
                $0.value = 1
                }.onChange() {
                    if $0.value == nil {
                        $0.value = 1
                    }
            }

            <<< MultipleSelectorRow<String>("features") {
                $0.title = $0.tag?.capitalized
                $0.options = ["Covered", "Charging", "Guarded", "Surveillance", "Illuminated"]
            }

            +++ TextAreaRow("instructions") {
                $0.placeholder = $0.tag?.capitalized
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
            }

            +++ SegmentedRow<String>("ptype") {
                $0.options = ["Driveway", "Garage", "Lot", "Structure", "Unpaved"]
                $0.value = "Driveway"
            }

            <<< SegmentedRow<String>("ltype") {
                $0.options = ["Residential", "Business"]
                $0.value = "Residential"
            }

            <<< TextRow("business name") {
                $0.title = $0.tag?.capitalized
                $0.placeholder = "e.g. Sam's Lot"
                $0.hidden = "$ltype != 'Business'"
            }

            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Upload images of your space") {
                $0.tag = "images"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Add New Image"
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return ImageRow() {
                        $0.title = "Upload Image \(index+1)"
                    }
                }
            }
    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

