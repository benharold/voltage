//
//  PeerTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/6/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Fakery
@testable import Voltage

class CreatedInvoiceTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()
    
    let faker = Faker(locale: "en-US")
    
    func testCreateInvoiceIsDecodable() throws {
        //        self.measure {
        let result: CreatedInvoiceResult
        guard let socket = LightningRPCSocket.create() else {
            throw SocketError.unwrap_error
        }
        let label = "\"test" + faker.lorem.word() + "\""
        let query = LightningRPCQuery(
            id: Int(getpid()),
            method: "invoice",
            params: ["1000", label, "\"test description\""]
        )
        let response: Data = socket.send(query: query)
        do {
            result = try decoder.decode(CreatedInvoiceResult.self, from: response)
            print(result)
            // I need to figure out how to assert that the result object
            // is the expected type
        } catch {
            print("Error: \(error)")
        }
        //        }
    }

}
