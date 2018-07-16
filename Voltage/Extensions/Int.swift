//
//  Int.swift
//  Voltage
//
//  Created by Ben Harold on 7/13/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

extension Int {
    func to_date_string() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        formatter.locale = NSLocale.current
        
        return formatter.string(from: date)
    }
}
