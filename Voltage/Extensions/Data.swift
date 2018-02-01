//
//  Data.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

extension Data {
    func to_string() -> String {
        let string_value = String(data: self, encoding: .utf8) as String!
        return string_value!
    }
}
