//
//  Output.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

// On-blockchain UTXO
struct FundOutput: Codable {
    let txid: String
    let output: Int
    let value: Int
}

// In-channel BTC
struct FundChannel: Codable {
    let peer_id: String
    let short_channel_id: String?
    let channel_sat: Int
    let channel_total_sat: Int
    let funding_txid: String
}

struct FundList: Codable {
    let outputs: [FundOutput]
    let channels: [FundChannel]
    
    enum ResultKey: String, CodingKey {
        case result
    }
}

struct FundResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: FundList
}
