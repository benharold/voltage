//
//  AppDelegate.swift
//  Voltage
//
//  Created by Ben Harold on 1/25/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Setup the RPC error observer. It watches for `Notification`s of type
        // "RPC Error" and displays an alert when it sees them.
        add_rpc_error_observer()
        
        // Check the RPC connection after setting up the observer. If there is a
        // problem the error observer should alert the user of the tragedy.
        _ = LightningRPCSocket.create()
        
        // Now that socket is okay, load all of the main table view data.
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func add_rpc_error_observer() {
        let notification_name = Notification.Name(rawValue: "RPC Error")
        NotificationCenter.default.addObserver(forName: notification_name, object: nil, queue: nil, using: { (notification) in
            print("rpc observer notification", notification)
            let error_text: String = String(describing: notification.object!)
            // Anything that messes with the UI has to be done in the main thread
            DispatchQueue.main.async {
                self.alert_rpc_error(header: notification.name.rawValue, body: error_text)
            }
        })
    }
    
    func alert_rpc_error(header: String, body: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Dang")
        //alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }

}
