//
//  createinvoice.swift
//  Voltage
//
//  Created by Ben Harold on 7/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct CreatedInvoice: Codable {
    let payment_hash: String
    let expiry_time: Int
    let expires_at: Int
    let bolt11: String
}

struct CreatedInvoiceResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: CreatedInvoice
}
