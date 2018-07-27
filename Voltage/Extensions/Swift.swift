//
//  Swift.swift
//  Voltage
//
//  Created by Ben Harold on 7/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

// Add the output of the `print()` method to a static buffer. This allows us to
// view said output in an application window, specifically, the "Debug" window.
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    // join multiple arguments if necessary
    let output = items.map { "\($0)" }.joined(separator: separator)
    
    // store the printed string in a buffer
    DebugStorage.buffer += output + terminator
    
    // let the debug window controller know it needs to update it's text view
    let note = Notification.init(name: Notification.Name.debug_message)
    NotificationCenter.default.post(note)
    
    // pass along to the standard swift print method
    Swift.print(output, terminator: terminator)
}
