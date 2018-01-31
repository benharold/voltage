//
//  Payment.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation
import Fakery

protocol PaymentFactory {
    static func fake() -> Payment
}

struct Payment: Codable, PaymentFactory {
    let id: Int
    let payment_hash: String
    let destination: String
    let msatoshi: Int
    let timestamp: Int
    let created_at: Int
    let status: String

    enum PaymentKeys: String, CodingKey {
        case payments
    }

    static func fake() -> Payment {
        let faker = Faker(locale: "en-US")
        let statuses = ["complete", "failed"]
        let status = Int(arc4random_uniform(UInt32(statuses.count)))

        return Payment(
            id: faker.number.randomInt(),
            payment_hash: PaymentHash.fake().value,
            destination: PaymentHash.fake().value,
            // minimum of 1 Satoshi, maximum of 10,000
            msatoshi: faker.number.randomInt(min: 1000, max: 1000 * 10000),
            timestamp: Int(NSDate().timeIntervalSince1970),
            created_at: Int(NSDate().timeIntervalSince1970),
            status: statuses[status]
        )
    }
}

struct PaymentList: Codable {
    let payments: [Payment]
}
