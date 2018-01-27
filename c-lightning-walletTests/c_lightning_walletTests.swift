//
//  c_lightning_walletTests.swift
//  c-lightning-walletTests
//
//  Created by Ben Harold on 1/25/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Fakery
@testable import c_lightning_wallet

class c_lightning_walletTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func loadJson(file_name: String) -> String? {
        let file_type = "json"
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file_name, ofType: file_type)!
        
        do {
            let json = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            //print(json)
            return json
        } catch {
            print("Other error: \(error)")
        }
        return nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }
    
    func testParseListPayments() {
        let json_data = loadJson(file_name: "listpayments")
        
        let decoder = JSONDecoder.init()
        do {
            let result = try decoder.decode(PaymentList.self, from: json_data!.data(using: .utf8)!)
            print(result.payments[0])
        } catch {
            print("Error: \(error)")
        }
    }
    
    func testParseListPeers() {
        let json_data = loadJson(file_name: "listpeers")
        
        let decoder = JSONDecoder.init()
        do {
            let result = try decoder.decode(PeerList.self, from: json_data!.data(using: .utf8)!)
            print(result.peers[5])
        } catch {
            print("Error: \(error)")
        }
    }
    
    func testCreateFakeStuff() {
        let faker = Faker(locale: "en-US")
        print(faker.name.firstName())
    }
    
    func testUseFactoryToCreatePayment() {
        let new_payment = Payment.fake()
        print("your mother is a whore")
        print(new_payment)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
