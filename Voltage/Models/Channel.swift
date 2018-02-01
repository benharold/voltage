//
//  Channel.swift
//  Voltage
//
//  Created by Ben Harold on 1/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

//struct Channel: Codable {
//    let state: String
//    let owner: String?
//    let short_channel_id: String?
//    let funding_txid: String?
//    let msatoshi_to_us: Int?
//    let msatoshi_total: Int?
//    let dust_limit_satoshis: Int
//    // TODO: This is bigger than 64 bits
//    //let max_htlc_value_in_flight_msat: BigInt
//    let channel_reserve_satoshis: Int
//    let htlc_minimum_msat: Int
//    let to_self_delay: Int
//    let max_accepted_htlcs: Int
//
//    enum ChannelKeys: String, CodingKey {
//        case channels
//    }
//}

struct Channel: Codable {
    let source: String
    let destination: String
    let short_channel_id: String
    let flags: Int
    let active: Bool
    let `public`: Bool
    let last_update: Int?
    let base_fee_millisatoshi: Int?
    let fee_per_millionth: Int?
    let delay: Int?
}

struct ChannelList: Codable {
    let channels: [Channel]
    
    enum ResultKey: String, CodingKey {
        case result
    }
}

struct ChannelResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: ChannelList
}
