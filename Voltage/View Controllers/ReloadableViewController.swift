//
//  ReloadableViewController.swift
//  Voltage
//
//  Created by Ben Harold on 6/22/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class ReloadableViewController: NSViewController {
    
    // The tab index is used to determine which ViewController should reload.
    var tab_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handle_reload_notification),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func reload() {
        print("The `reload()` method is not defined for this ViewController")
    }
    
    // Only run reload() on the currently selected tab's ViewController.
    @objc func handle_reload_notification(notification: NSNotification) {
        if let tab_controller = self.parent as? NSTabViewController {
            if tab_controller.selectedTabViewItemIndex == self.tab_index {
                self.reload()
            }
        }
    }

}
