//
//  PaymentClient.swift
//  Curbd
//
//  Created by Farbod Rafezy on 8/6/18.
//  Copyright © 2018 Farbod Rafezy. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class PaymentClient: NSObject, STPEphemeralKeyProvider {

    static let sharedClient = PaymentClient()

    static func calculateCustomerPrice(pricing: Int, minutes: Int) -> Int {
        let preProcessingFeePrice = Double(pricing) * Double(minutes) / 60.0
        let price = (preProcessingFeePrice + 30) * (1.0 / (1.0 - 0.029))
        return Int(round(price))
    }

    func completeReservationCharge(_ result: STPPaymentResult,
                        amount: Int,
                        statementDescriptor: String,
                        reservationId: Int,
                        completion: @escaping STPErrorBlock) {

        if let token = UserDefaults.standard.string(forKey: "token") {
            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            let parameters: [String: Any] = [
                "amount": amount,
                "source": result.source.stripeID,
                "statement_descriptor": statementDescriptor,
                "reservation_id": reservationId,
            ]

            Alamofire.request(
                baseURL + "/api/payment/charge_reservation/",
                method: .post,
                parameters: parameters,
                headers: headers)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
            }
        }

    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let headers: HTTPHeaders = [
                "Authorization": "Token \(token)",
            ]

            let parameters: Parameters = [
                "api_version": apiVersion,
            ]

            Alamofire.request(
                baseURL + "/api/payment/ephemeral_keys/",
                method: .post,
                parameters: parameters,
                headers: headers).validate(statusCode: 200..<300).responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        completion(json as? [String: AnyObject], nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
            }

        }
    }

    static func requestVenmoPayout(withToken token: String,
                                   venmoAddress: String?,
                                   venmoAddressType: String?,
                                   completion: @escaping (Error?) -> Void) {

        let headers: HTTPHeaders = [
            "Authorization": "Token \(token)",
        ]

        var parameters: Parameters = [:]

        if let venmoAddress = venmoAddress, let venmoAddressType = venmoAddressType {
            parameters["venmo_address"] = venmoAddress
            parameters["venmo_address_type"] = venmoAddressType
        }


        Alamofire.request(
            baseURL + "/api/payment/venmo_payout/",
            method: .post,
            parameters: parameters,
            headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }

    }

}

