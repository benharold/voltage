//
//  AddressServiceTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class AddressServiceTest: XCTestCase {

    func test_get_new_address() {
        let new_address = AddressService.generate()
        
        XCTAssert(new_address!.count >= 26)
        XCTAssert(new_address!.count <= 35)
    }

}
