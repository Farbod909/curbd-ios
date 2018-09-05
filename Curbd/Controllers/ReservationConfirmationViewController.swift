//
//  ReservationConfirmationViewController.swift
//  Curbd
//
//  Created by Farbod Rafezy on 4/21/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Stripe

class ReservationConfirmationViewController: DarkTranslucentViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var arriveDateLabel: UILabel!
    @IBOutlet weak var leaveDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vehicleLicensePlateLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    var parkingSpace: ParkingSpace?
    var arriveDate: Date?
    var leaveDate: Date?
    var price: Int?
    // The reservation that has been created. Value is nil
    // until user succesfully reserves a spot by confirming.
    var createdReservation: Reservation?

    var paymentContext: STPPaymentContext?
    var loadingView = LoadingView()

    func initializeAppearanceSettings() {
        mapView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAppearanceSettings()

        if  let parkingSpace = parkingSpace,
            let arriveDate = arriveDate,
            let leaveDate = leaveDate,
            let price = price,
            let vehicleLicensePlate = UserDefaults.standard.string(
                forKey: "vehicle_license_plate") {

            nameLabel.text = parkingSpace.name
            arriveDateLabel.text = arriveDate.toHumanReadable()
            leaveDateLabel.text = leaveDate.toHumanReadable()

            let reservationTimeMinutes = Int(leaveDate.timeIntervalSince(arriveDate) / 60)

            let customerContext = STPCustomerContext(keyProvider: PaymentClient.sharedClient)
            paymentContext = STPPaymentContext(customerContext: customerContext)
            paymentContext?.paymentAmount = price
            paymentContext?.paymentCurrency = "usd"
            if #available(iOS 11.0, *) {
                paymentContext?.largeTitleDisplayMode = .never
            }

            paymentContext?.delegate = self
            paymentContext?.hostViewController = self

            
            vehicleLicensePlateLabel.text = vehicleLicensePlate

            totalTimeLabel.text = TimeIntervalFormatter.humanReadableStringFrom(reservationTimeMinutes)

            confirmButton.setTitle("Pay \(paymentContext?.paymentAmount.toUSDRepresentation() ?? "")", for: .normal)

            let parkingSpaceLocation = CLLocation(
                latitude: parkingSpace.latitude,
                longitude: parkingSpace.longitude)
            mapView.centerOn(location: parkingSpaceLocation)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(
                parkingSpace.latitude,
                parkingSpace.longitude)
            mapView.addAnnotation(annotation)

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(parkingSpaceLocation) { placemarks, error in
                if error == nil {
                    if  let city = placemarks?[0].locality,
                        let state = placemarks?[0].administrativeArea {
                        self.cityStateLabel.text = "\(city), \(state)"
                    }
                }
            }
        }

    }
    @IBAction func paymentMethodButtonClick(_ sender: UIButton) {
        paymentContext?.presentPaymentMethodsViewController()
    }

    @IBAction func confirmReservationClick(_ sender: UIButton) {
        paymentContext?.requestPayment()
    }

    @IBAction func cancelButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension ReservationConfirmationViewController: STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {

        if  let parkingSpace = parkingSpace,
            let arriveDate = arriveDate,
            let leaveDate = leaveDate {

            if let token = UserDefaults.standard.string(forKey: "token") {
                if let currentVehicleID = UserDefaults.standard.string(forKey: "vehicle_id") {

                    startLoading(loadingView)
                    Reservation.create(
                        withToken: token,
                        for: parkingSpace,
                        withVehicle: currentVehicleID,
                        from: arriveDate,
                        to: leaveDate,
                        cost: paymentContext.paymentAmount,
                        paymentMethodInfo: (paymentContext.selectedPaymentMethod?.label)!) { error, reservation in
                            if let reservation = reservation {
                                self.createdReservation = reservation
                                PaymentClient.sharedClient.completeCharge(
                                    paymentResult,
                                    amount: (self.paymentContext?.paymentAmount)!,
                                    statementDescriptor: "Curbd Reservation",
//                                    metadata: ["reservation_id": 2734],
                                    completion: completion)

                            } else {
                                self.stopLoading(self.loadingView)
                                self.presentServerErrorAlert() { action in
                                    self.performSegue(
                                        withIdentifier:
                                        "unwindToMapViewControllerAfterReservationConfirmation",
                                        sender: self)
                                }
                            }
                    }

                } else {
                    self.presentSingleButtonAlert(
                        title: "Add a Vehicle First",
                        message: "You need to add a vehicle before you can reserve a spot.") { action in
                            self.performSegue(
                                withIdentifier:
                                "unwindToMapViewControllerAfterReservationConfirmation",
                                sender: self)
                    }
                }
            } else {
                self.presentSingleButtonAlert(
                    title: "Not Authenticated",
                    message: "Looks like you're not logged in. Try logging in first.") { action in
                        self.performSegue(
                            withIdentifier:
                            "unwindToMapViewControllerAfterReservationConfirmation",
                            sender: self)
                }
            }
        }
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {

        stopLoading(loadingView)

        switch status {
        case .error:

            if let createdReservation = createdReservation {
                if let token = UserDefaults.standard.string(forKey: "token") {
                    createdReservation.delete(withToken: token)
                }
            }
            
            self.presentSingleButtonAlert(
                title: "Error",
                message: error?.localizedDescription ?? "")
        case .success:
            self.presentSingleButtonAlert(
                title: "Successfully Reserved",
                message: "You successfully reserved this parking space!") { action in
                    self.performSegue(
                        withIdentifier:
                        "unwindToMapViewControllerAfterReservationConfirmation",
                        sender: self)
            }
        case .userCancellation:
            return
        }
    }

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = self.paymentContext?.selectedPaymentMethod {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        }
        else {
            paymentMethodButton.setTitle("Select Payment", for: .normal)
        }
        confirmButton.setTitle("Pay \(paymentContext.paymentAmount.toUSDRepresentation())", for: .normal)

    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
}
