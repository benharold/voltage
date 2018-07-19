//
//  PopoverManager.swift
//  Voltage
//
//  Created by Ben Harold on 7/19/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

// Keep track of open popovers
//
// Some of the popovers used in Voltage have their behavior
// defined as semitransient: `popover?.behavior = .semitransient`,
// which allows the use of alert modals without closing the popover.
//
// This class allows us to keep track of any open popover so that
// we can close it when necessary.
class PopoverManager: NSObject {
    private static var _current: NSPopover?
    static var current: NSPopover? {
        set {
            if _current != nil {
                _current?.close()
            }
            
            _current = newValue
        }
        get {
            return _current
        }
    }
}
