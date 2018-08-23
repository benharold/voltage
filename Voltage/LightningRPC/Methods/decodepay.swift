//
//  decodepay.swift
//  Voltage
//
//  Created by Ben Harold on 7/18/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Bolt11Invoice: Codable {
    let currency: String
    let timestamp: Int
    let created_at: Int
    let expiry: Int
    let payee: String
    let msatoshi: Int
    let description: String
    let min_final_cltv_expiry: Int
    let payment_hash: String
    let signature: String
}

struct Bolt11InvoiceResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: Bolt11Invoice
}
