//
//  Invoice.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Invoice: Codable {
    let label: String
    let payment_hash: String
    let msatoshi: Int
    let status: String
    let pay_index: Int?
    let msatoshi_received: Int?
    let paid_timestamp: Int?
    let paid_at: Int?
    let expiry_time: Int
    let expires_at: Int
}

struct InvoiceList: Codable {
    let invoices: [Invoice]
    
    enum ResultKey: String, CodingKey {
        case result
    }
}

struct InvoiceResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: InvoiceList
}
