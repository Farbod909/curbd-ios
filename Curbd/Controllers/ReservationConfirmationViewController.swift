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
    var pricing: Int?

    var paymentContext: STPPaymentContext?

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
            let pricing = pricing,
            let vehicleLicensePlate = UserDefaults.standard.string(
                forKey: "vehicle_license_plate") {

            nameLabel.text = parkingSpace.name
            arriveDateLabel.text = arriveDate.toHumanReadable()
            leaveDateLabel.text = leaveDate.toHumanReadable()

            let reservationTimeMinutes = Int(leaveDate.timeIntervalSince(arriveDate) / 60)
//            let pricePerHour = Double(pricing)/100.0
//            let finalCost = (reservationTimeMinutes / 60.0) * pricePerHour
//            let formattedFinalCost = String(format: "%.02f", finalCost)
            let price = PaymentClient.calculateCustomerPrice(pricing: pricing, minutes: reservationTimeMinutes)

            let customerContext = STPCustomerContext(keyProvider: PaymentClient.sharedClient)
            paymentContext = STPPaymentContext(customerContext: customerContext)
            paymentContext?.paymentAmount = price
            paymentContext?.paymentCurrency = "usd"

            paymentContext?.delegate = self
            paymentContext?.hostViewController = self

            
            vehicleLicensePlateLabel.text = vehicleLicensePlate

            totalTimeLabel.text = "\(Int(reservationTimeMinutes))min"

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
        PaymentClient.sharedClient.completeCharge(paymentResult,
                                                  amount: (self.paymentContext?.paymentAmount)!,
                                                  statementDescriptor: "Curbd Reservation",
//                                                  metadata: ["reservation_id": 2734],
                                                  completion: completion)
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .error:
            self.presentSingleButtonAlert(
                title: "Error",
                message: error?.localizedDescription ?? "")
        case .success:
            if  let parkingSpace = parkingSpace,
                let arriveDate = arriveDate,
                let leaveDate = leaveDate {

                Reservation.create(
                    for: parkingSpace,
                    from: arriveDate,
                    to: leaveDate,
                    cost: paymentContext.paymentAmount,
                    paymentMethodInfo: (paymentContext.selectedPaymentMethod?.label)!) { title, message in
                        self.presentSingleButtonAlert(
                            title: title,
                            message: message) { action in
                                self.performSegue(
                                    withIdentifier:
                                    "unwindToMapViewControllerAfterReservationConfirmation",
                                    sender: self)
                        }
                }
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