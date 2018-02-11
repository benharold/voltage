//
//  ErrorResult.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct ErrorResult: Codable {
    let id: Int
    let jsonrpc: String
    let error: String
}
