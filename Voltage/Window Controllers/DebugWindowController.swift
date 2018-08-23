//
//  DebugWindowController.swift
//  Voltage
//
//  Created by Ben Harold on 7/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class DebugWindowController: NSWindowController {

    @IBOutlet var debug_window_text: NSTextView!
    
    override func windowDidLoad() {
        update_contents()
        listen_for_debug_messages()
    }
    
    func listen_for_debug_messages() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_contents), name: Notification.Name.debug_message, object: nil)
    }
    
    @objc func update_contents() {
        DispatchQueue.main.async {
            self.debug_window_text.textStorage?.setAttributedString(NSAttributedString(string: DebugStorage.buffer))
            self.debug_window_text.textStorage?.font = NSFont.init(name: "Consolas", size: 13)
            self.debug_window_text.textColor = NSColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
}
