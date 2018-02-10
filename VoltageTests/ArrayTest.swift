//
//  ArrayTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 2/10/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest

class ArrayTest: XCTestCase {

    let test_array = [
        "just",
        "for",
        "fun"
    ]
    
    // Just figuring out the best way to iterate over an array with the index
    // value in Swift 4.
    func test_iterate_over_array_with_index() {
        
//        for x in 0...test_array.count {
//            print(x)
//            XCTAssert(test_array[x] != nil) // out of range for 3
//        }
        
        for (key, value) in test_array.enumerated() {
            print(key, value)
            XCTAssert(test_array[key] == value)
        }
        
    }

}
