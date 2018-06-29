//
//  LightningRPCTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class LightningRPCTest: XCTestCase {

    func test_can_create_valid_rpc() {
        let rpc = LightningRPC(method: "getinfo")
        XCTAssert((rpc != nil) as Bool)
    }
    
    func test_cannot_create_invalid_rpc() {
        let rpc = LightningRPC(method: "invalid")
        XCTAssert((rpc == nil) as Bool)
    }
    
}
