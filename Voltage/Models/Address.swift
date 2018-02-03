//
//  Address.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Address: Codable {
    let address: String
    
    enum ResultKey: String, CodingKey {
        case result
    }
}

struct AddressResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: Address
}
