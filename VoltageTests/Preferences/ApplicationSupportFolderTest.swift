//
//  ApplicationSupportFolderTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 7/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class ApplicationSupportFolderTest: XCTestCase {

    func testGetFolderPath() {
        let app_support = ApplicationSupportFolder()
        let expected = NSString(string: "~/Library/Application Support/Voltage").expandingTildeInPath
        XCTAssert(expected == app_support.path)
    }

}
