//
//  PerferencesTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 7/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class PerferencesTest: XCTestCase {
    
    var prefs = Preferences()

    func testGetAndSetNodeLocation() {
        let location = NodeLocation.remote
        prefs.node_location = NodeLocation.remote
        XCTAssert(prefs.node_location == NodeLocation.remote)
        prefs.node_location = NodeLocation.local
        XCTAssert(prefs.node_location == NodeLocation.local)
    }

}
