//
//  ChannelsTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class ChannelsTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()

    func testListChannelsIsDecodable() {
//        self.measure {
            let socket = LightningRPCSocket.create()
            let query = LightningRPCQuery(
                id: Int(getpid()),
                method: "listchannels",
                params: []
            )
            let response: Data = socket.send(query: query)
            do {
                let result = try decoder.decode(ChannelResult.self, from: response)
                print(result)
                // I need to figure out how to assert that the result object
                // is the expected type
            } catch {
                print("Error: \(error)")
            }
//        }
    }
}
