//
//  PeerTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/6/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class PeerTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()
    
    func testListPeersIsDecodable() {
        //        self.measure {
        let result: PeerResult
        let socket = LightningRPCSocket.create()
        let query = LightningRPCQuery(
            id: Int(getpid()),
            method: "listpeers",
            params: []
        )
        let response: Data = socket.send(query: query)
        do {
            result = try decoder.decode(PeerResult.self, from: response)
            print(result)
            // I need to figure out how to assert that the result object
            // is the expected type
        } catch {
            print("Error: \(error)")
        }
        //        }
    }

}
