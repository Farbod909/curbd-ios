//
//  AddParkingSpaceViewController.swift
//  Curbd
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSettings()
        initializeForm()
    }

    func initializeForm() {

        form
            +++ Section("Details")
            <<< NameRow("address1") {
                $0.placeholder = "Street and number"
            }

            <<< TextRow("address2") {
                $0.placeholder = "Apartment, suite #, etc."
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

            +++ IntRow("available spots") {
                $0.title = $0.tag?.capitalized
                $0.value = 1
                }.onChange() {
                    if $0.value == nil {
                        $0.value = 1
                    }
            }

            <<< PushRow<String>("size") {
                $0.title = $0.tag?.capitalized
                $0.options = []
                for size in Array(Vehicle.sizeDescriptions.keys).sorted() {
                    if size > 1 {
                        $0.options?.append(Vehicle.sizeDescriptions[size]!)
                    }
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }

            <<< MultipleSelectorRow<String>("features") {
                $0.title = $0.tag?.capitalized
                $0.options = ["Covered", "EV Charging", "Guarded",
                              "Surveillance", "Illuminated", "Gated"]
            }

            +++ SegmentedRow<String>("physicaltype") {
                $0.options = ["Driveway", "Garage", "Lot", "Structure", "Unpaved"]
                $0.value = "Driveway"
            }

            <<< SegmentedRow<String>("legaltype") {
                $0.options = ["Residential", "Business"]
                $0.value = "Residential"
            }

            <<< TextRow("business name") {
                $0.title = $0.tag?.capitalized
                $0.placeholder = "e.g. Sam's Lot"
                $0.hidden = "$legaltype != 'Business'"
            }

            +++ TextAreaRow("instructions") {
                $0.placeholder = $0.tag?.capitalized
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
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
                    return ImageRow("image \(index)") {
                        $0.title = "Upload Image \(index+1)"
                    }
                }
            }
    }

    @IBAction func nextButtonClick(_ sender: UIBarButtonItem) {
        let parkingSpaceDetailTableViewController = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(withIdentifier: "parkingSpaceDetailTableViewController") as! ParkingSpaceDetailTableViewController

        if  let address1 = (form.rowBy(tag: "address1") as? NameRow)?.value,
            let zipCode = (form.rowBy(tag: "zip code") as? ZipCodeRow)?.value,
            let city = (form.rowBy(tag: "city") as? NameRow)?.value,
            let state = (form.rowBy(tag: "state") as? TextRow)?.value,
            let availableSpots = (form.rowBy(tag: "available spots") as? IntRow)?.value,
            let sizeString = (form.rowBy(tag: "size") as? PushRow<String>)?.value,
            let featureSet = (form.rowBy(tag: "features") as? MultipleSelectorRow<String>)?.value,
            let physicalType = (form.rowBy(tag: "physicaltype") as? SegmentedRow<String>)?.value,
            let legalType = (form.rowBy(tag: "legaltype") as? SegmentedRow<String>)?.value,
            let instructions = (form.rowBy(tag: "instructions") as? TextAreaRow)?.value {

            let address2 = (form.rowBy(tag: "address2") as? TextRow)?.value

            var images = [UIImage]()
            for (key, value) in form.values() {
                if key.starts(with: "image") {
                    if let image = value as? UIImage {
                        images.append(image)
                    }
                }
            }

            if let token = UserDefaults.standard.string(forKey: "token") {

                var name = address1
                if legalType == "Business" {
                    if let businessName = ((form.rowBy(tag: "business name") as? TextRow)?.value) {
                        name = businessName
                    } else {
                        presentSingleButtonAlert(
                            title: "Incomplete Fields",
                            message: "Please make sure all fields are completed.")
                    }
                }

                ParkingSpace.create(
                    withToken: token,
                    address1: address1,
                    address2: address2,
                    city: city,
                    state: state,
                    code: zipCode,
                    available_spaces: availableSpots,
                    features: featureSet,
                    physical_type: physicalType,
                    legal_type: legalType,
                    name: name,
                    instructions: instructions,
                    sizeDescription: sizeString,
                    images: images) { error, parkingSpace in

                        if let parkingSpace = parkingSpace {
                            parkingSpaceDetailTableViewController.isPreview = true
                            parkingSpaceDetailTableViewController.parkingSpace = parkingSpace
                            self.show(parkingSpaceDetailTableViewController, sender: self)
                        } else {
                            if let error = error as? ValidationError {
                                self.presentValidationErrorAlert(from: error)
                            } else {
                                self.presentServerErrorAlert()
                            }
                        }

                }
            }

        } else {
            presentSingleButtonAlert(
                title: "Incomplete Fields",
                message: "Please make sure all fields are completed.")
        }

    }

    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

