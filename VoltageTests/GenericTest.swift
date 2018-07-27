//
//  GenericTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 7/19/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.

import XCTest
@testable import Voltage

class GenericTest: XCTestCase {

    func testGenerics() {
        //sleep(1)
        if let result: Data = rpc(LightningRPC.Method.getinfo) {
            Swift.print(result.to_string())
        }
        
        if let generic: GetInfoResult = typed_rpc(LightningRPC.Method.getinfo) {
            Swift.print(generic.result)
        }
    }
    
    func rpc(_ method: LightningRPC.Method) -> Data? {
        guard let socket = LightningRPCSocket.create() else { return nil }
        let query = LightningRPCQuery(method)
        let response: Data = socket.send(query)
        
        return response
    }
    
    func typed_rpc<T: Decodable>(_ method: LightningRPC.Method) -> T? {
        guard let socket = LightningRPCSocket.create() else { return nil }
        let query = LightningRPCQuery(method)
        let response: Data = socket.send(query)
        let decoder = JSONDecoder()
        do {
            let result: T = try decoder.decode(T.self, from: response)
            return result
        } catch {
            Swift.print(error)
        }

        return nil
    }
    
}
