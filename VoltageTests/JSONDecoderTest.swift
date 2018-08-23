//
//  JSONDecoderTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 1/25/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Fakery
@testable import Voltage

class JSONDecoderTest: XCTestCase {
    
    // Load JSON data from a static file located in the test directory
    func loadJson(file_name: String) -> String? {
        let file_type = "json"
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file_name, ofType: file_type)!
        
        do {
            let json = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            //print(json)
            return json
        } catch {
            Swift.print("Other error: \(error)")
        }
        return nil
    }
    
    func testParseListPayments() {
        let json_data = loadJson(file_name: "listpayments")
        
        let decoder = JSONDecoder.init()
        do {
            let result = try decoder.decode(PaymentList.self, from: json_data!.data(using: .utf8)!)
            Swift.print(result.payments[0])
        } catch {
            Swift.print("Error: \(error)")
        }
    }
    
    func testParseListPeers() {
        let json_data = loadJson(file_name: "listpeers")
        
        let decoder = JSONDecoder.init()
        do {
            let result = try decoder.decode(PeerList.self, from: json_data!.data(using: .utf8)!)
            Swift.print(result.peers[5])
        } catch {
            Swift.print("Error: \(error)")
        }
    }
    
    func testUseFactoryToCreatePayment() {
        let new_payment = Payment.fake()
        Swift.print(new_payment)
    }
    
}
