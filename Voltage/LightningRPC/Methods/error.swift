//
//  ErrorResult.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct RPCError: Codable, Error {
    let code: Int
    let message: String
}

struct ErrorResult: Codable {
    let id: Int
    let jsonrpc: String
    let error: RPCError
}
