//
//  InvoiceTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class InvoiceTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()
    
    func testListInvoicesIsDecodable() throws {
        //        self.measure {
        let result: InvoiceResult
        guard let socket = LightningRPCSocket.create() else {
            throw SocketError.unwrap_error
        }
        let query = LightningRPCQuery(
            id: Int(getpid()),
            method: "listinvoices",
            params: []
        )
        let response: Data = socket.send(query: query)
        do {
            result = try decoder.decode(InvoiceResult.self, from: response)
            // I need to figure out how to assert that the result object
            // is the expected type
            print(result)
        } catch {
            print("Error: \(error)")
        }
        //        }
    }
}
