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
    
    lazy var debug_controller = DebugWindowController(windowNibName: NSNib.Name.debug)
    
    lazy var prefernces_controller = PreferencesWindowController(windowNibName: NSNib.Name.preferences)
    
    @IBAction func prefernces_button(_ sender: Any) {
        open_preferences_window()
    }
    
    @IBAction func debug_button(_ sender: Any) {
        open_debug_window()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // The SSHTunnel object sends `stderr` output to a pipe which is
        // broadcast with the NSFileHandleDataAvailable notification. So
        // basically this is listening for problems with a remote ssh tunnel.
        listen_for_NSFileHandleDataAvailable()
        
        // Check to see if this is the first time the user has run Voltage.
        // If it is the first run, attempt to connect to a local c-lightning
        // socket. If that fails, show the Preferences window.
        //
        // Preferences are persistent, even across builds, so this should only
        // be triggered the first time the user ever opens Voltage.
        var prefs = Preferences()
        if !prefs.setup_complete {
            first_run(&prefs)
        }
        
        // Setup the RPC error observer. It watches for `Notification`s of type
        // "rpc_rror" and displays an alert when it sees them.
        //
        // This needs to be after first run, as we might be dealing with some
        // errors during that step that we don't necessarily want to tell the
        // user about.
        add_rpc_error_observer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func listen_for_NSFileHandleDataAvailable() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handle_NSFileHandleDataAvailable),
                                               name: NSNotification.Name.NSFileHandleDataAvailable,
                                               object: nil)
    }
    
    @objc func handle_NSFileHandleDataAvailable(note: Notification) {
        if let message = note.object as? FileHandle {
            print(note)
            let message_string: String = message.availableData.to_string()
            alert_error(header: "SSH Tunnel Error", body: message_string)
        } else {
            print(note.object!)
        }
    }
    
    // FIXME: This is just hot garbage
    func add_rpc_error_observer() {
        let notification_name = Notification.Name.rpc_error
        NotificationCenter.default.addObserver(forName: notification_name, object: nil, queue: nil, using: { (notification) in
            print("rpc observer notification", notification)
            var message: String = ""
            
            if let rpc_error: RPCError = notification.object as? RPCError {
                // RPCErrors have a code and a message string
                message = rpc_error.message
            } else {
                message = String(describing: notification.object!)
            }
            
            if let user_info: [AnyHashable: Any] = notification.userInfo {
                if var socket_path = user_info["socket_path"] as? String {
                    socket_path = "Socket path: " + socket_path
                    message += "\n\n" + socket_path
                }
            }
            // Anything that messes with the UI has to be done in the main thread
            DispatchQueue.main.async {
                self.alert_error(header: "RPC Error", body: message)
            }
        })
    }
    
    func alert_error(header: String, body: String) {
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Dang")
        alert.runModal()
    }
    
    func open_debug_window() {
        debug_controller.showWindow(self)
    }
    
    func open_preferences_window() {
        prefernces_controller.showWindow(self)
    }
    
    // Handle initial setup of the application
    func first_run(_ prefs: inout Preferences) {
        print("Thanks for trying Voltage!")
        // First try the default socket and see if that works. If it does, just
        // load the program, otherwise open the Preferences window.
        if let rpc = LightningRPCSocket.create() {
            if (rpc.socket?.isConnected)! {
                // TODO: send a "Welcome to Voltage" message
                prefs.setup_complete = true
                return
            } else {
                // This shouldn't happen, but we all know how that works out.
                print("RPC socket is NOT connected, but WAS created...?")
            }
        } else {
            open_preferences_window()
        }
    }
}
