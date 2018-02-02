//
//  ChannelsTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Fakery
@testable import Voltage

class ChannelsTest: XCTestCase {
    let decoder: JSONDecoder = JSONDecoder.init()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testListChannelsIsDecodable() {
//        self.measure {
            let result: ChannelResult
            let socket = LightningRPCSocket.create()
            let query = LightningRPCQuery(
                id: Int(getpid()),
                method: "listchannels",
                params: []
            )
            let response: Data = socket.send(query: query)
            do {
                result = try decoder.decode(ChannelResult.self, from: response)
                // I need to figure out how to assert that the result object
                // is the expected type
            } catch {
                print("Error: \(error)")
            }
//        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
