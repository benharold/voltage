//
//  PaymentHash.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/27/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation
import Fakery

protocol PaymentHashFactory {
    static func fake() -> PaymentHash
}

struct PaymentHash: PaymentHashFactory {
    let value: String
    
    static func fake() -> PaymentHash {
        let faker = Faker(locale: "en-US")
        let fake_payment = faker.lorem.characters(amount: 8)
        return PaymentHash(value: fake_payment.sha256())
    }
}
