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
    
    func testListFundsIsDecodable() {
        //        self.measure {
        let result: FundResult
        let socket = LightningRPCSocket.create()
        let query = LightningRPCQuery(
            id: Int(getpid()),
            method: "listfunds",
            params: []
        )
        let response: Data = socket.send(query: query)
        print(response.to_string())
        do {
            result = try decoder.decode(FundResult.self, from: response)
            // I need to figure out how to assert that the result object
            // is the expected type
            print(result)
        } catch {
            print("Error: \(error)")
        }
        //        }
    }
}
