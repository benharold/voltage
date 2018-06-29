//
//  PreferencesViewController.swift
//  Voltage
//
//  Created by Ben Harold on 1/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    var preferences = Preferences()
    
    let default_socket_path: String = "~/.lightning/lightning-rpc"
    
    @IBOutlet weak var socket_location: NSTextFieldCell!
    
    @IBOutlet weak var socket_status: NSTextField!
    
    @IBOutlet weak var other: NSTextField!
    
    @IBAction func save_button(_ sender: Any) {
        save_preferences()
        view.window?.close()
    }
    
    @IBAction func cancel_button(_ sender: Any) {
        view.window?.close()
    }
    
    @IBAction func test_connection_button(_ sender: Any) {
        test_connection()
    }
    
    @IBAction func revert_to_default_button(_ sender: Any) {
        socket_location.stringValue = default_socket_path
    }
    
    func show_existing_preferences() {
        socket_location.stringValue = preferences.socket_path
    }
    
    func save_preferences() {
        preferences.socket_path = socket_location.stringValue
    }
    
    func test_connection() {
        guard let service = LightningRPCSocket(path: socket_location.stringValue) else {
            socket_status.stringValue = "Disconnected"
            socket_status.textColor = NSColor.red
            return
        }
        if (service.socket?.isConnected)! {
            socket_status.stringValue = "Connected"
            socket_status.textColor = NSColor.black
        } else {
            socket_status.stringValue = "Disconnected"
            socket_status.textColor = NSColor.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show_existing_preferences()
        test_connection()
    }
}
