//
//  Output.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Output: Codable {
    let txid: String
    let output: Int
    let value: Int
}

struct OutputList: Codable {
    let outputs: [Output]
    
    enum ResultKey: String, CodingKey {
        case result
    }
}

struct OutputResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: OutputList
}
