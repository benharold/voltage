//
//  Invoice.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct GetInfo: Codable {
    let id: String
    let port: Int
    let version: String
    let blockheight: Int
    let network: String
}

struct GetInfoResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: GetInfo
}
