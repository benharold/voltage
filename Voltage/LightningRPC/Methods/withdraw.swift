//
//  Withdraw.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Withdraw: Codable {
    let tx: String
    let txid: String
    
    enum ResultKey: String, CodingKey {
        case results
    }
}

struct WithdrawResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: Withdraw
}
