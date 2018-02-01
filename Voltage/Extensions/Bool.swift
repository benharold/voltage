//
//  Bool.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

extension Bool {
    func to_yes_no() -> String {
        if self {
            return "Yes"
        }
        
        return "No"
    }
}
