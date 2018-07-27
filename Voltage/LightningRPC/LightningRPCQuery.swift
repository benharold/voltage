//
//  LightningRPCQuery.swift
//  Voltage
//
//  Created by Ben Harold on 1/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct LightningRPCQuery: Encodable {
    let id: Int
    let method: String
    let params: [String]
    
    init(id: Int, method: String, params: [String] = []) {
        self.id = id
        self.method = method
        self.params = params
    }
    
    init(method: LightningRPC.Method, params: [String] = []) {
        self.id = Int(getpid())
        self.method = method.rawValue
        self.params = params
    }
    
    init(_ method: LightningRPC.Method) {
        self.id = Int(getpid())
        self.method = method.rawValue
        self.params = []
    }
}
