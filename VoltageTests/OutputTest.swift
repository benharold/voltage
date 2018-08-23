//
//  OutputTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class OutputTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()
    
    func testListFundsIsDecodable() throws {
        //        self.measure {
        let result: FundResult
        guard let socket = LightningRPCSocket.create() else {
            throw SocketError.unwrap
        }
        let query = LightningRPCQuery(
            id: Int(getpid()),
            method: "listfunds",
            params: []
        )
        let response: Data = socket.send(query)
        Swift.print(response.to_string())
        do {
            result = try decoder.decode(FundResult.self, from: response)
            // I need to figure out how to assert that the result object
            // is the expected type
            Swift.print(result)
        } catch {
            Swift.print("Error: \(error)")
        }
        //        }
    }
}
