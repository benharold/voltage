//
//  createinvoice.swift
//  Voltage
//
//  Created by Ben Harold on 7/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

// JSON decoder for an object returned by the `invoice` RPC
struct CreatedInvoice: Codable {
    let payment_hash: String
    let expiry_time: Int
    let expires_at: Int
    let bolt11: String
    // The invoice label is not returned by the `invoice` RPC nor the
    // `decodepay` RPC but it is used as the title of the invoice window. That's
    // why it is allowed to be manually set here.
    var label: String?
}

struct CreatedInvoiceResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: CreatedInvoice
}
