//
//  PreferencesWindowController.swift
//  Voltage
//
//  Created by Ben Harold on 7/27/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSTextFieldDelegate {
    
    var prefs = Preferences()
    var local_prefs = Preferences.Local()
    var remote_prefs = Preferences.Remote()
    let default_node_location = NodeLocation.local
    let default_socket_path = Constant.default_socket_path
    
    // MARK: Node Location Buttons
    @IBOutlet weak var local_button: NSButton!
    @IBOutlet weak var remote_button: NSButton!

    // MARK: Local Preferences
    @IBOutlet weak var socket_location: NSTextField!
    @IBOutlet weak var revert_to_default_button: NSButtonCell!
    
    // MARK: Remote Preferences
    @IBOutlet weak var remote_host: NSTextField!
    @IBOutlet weak var remote_port: NSTextField!
    @IBOutlet weak var remote_username: NSTextField!
    @IBOutlet weak var remote_socket_location: NSTextField!
    
    @IBOutlet weak var local_config_view: NSView!
    @IBOutlet weak var remote_config_view: NSView!
    @IBOutlet weak var public_key_warning: NSTextField!
    
    @IBOutlet weak var connection_status: NSTextField!

    @IBAction func change_node_location(_ sender: Any) {
        if local_button.state == NSControl.StateValue.on {
            remote_config_view.isHidden = true
            public_key_warning.isHidden = true
            local_config_view.isHidden = false
        }
        
        if remote_button.state == NSControl.StateValue.on {
            local_config_view.isHidden = true
            remote_config_view.isHidden = false
            public_key_warning.isHidden = false
        }
    }
    
    @IBAction func save_button(_ sender: Any) {
        save_preferences()
        NotificationCenter.default.post(name: Notification.Name.reload, object: nil)
        self.close()
    }
    
    @IBAction func cancel_button(_ sender: Any) {
        self.close()
    }
    
    @IBAction func test_connection_button(_ sender: Any) {
        // should I test the local or remote socket?
        if local_button.state == NSControl.StateValue.on {
            if test_local_connection() {
                alert_socket_is_connected()
            }
        } else {
            if test_remote_connection() {
                alert_socket_is_connected()
            }
        }
    }
    
    func test_remote_connection() -> Bool {
        if let socket_path: String = open_ssh_tunnel()?.path {
            // If we don't wait for the socket to exist here the test will take
            // place before the tunnel is fully established. Specifically,
            // the socket file will not be found in the filesystem.
            //
            // Let's give the socket 5 seconds to appear before we give up.
            let start = Date().timeIntervalSince1970
            let file_manager = FileManager()
            var keep_trying = true
            while keep_trying {
                // Once the socket file appears, go ahead with the test
                if file_manager.fileExists(atPath: socket_path) {
                    keep_trying = false
                }
                // If the file hasn't appeared in 5 seconds, give up
                if Date().timeIntervalSince1970 > start + 4 {
                    keep_trying = false
                }
            }
            return test_connection(socket_path: socket_path)
        }

        return false
    }
    
    func open_ssh_tunnel() -> URL? {
        let local = ApplicationSupportFolder().path + "/lightning-rpc"
        let tunnel = SSHTunnel(host: Host(address: remote_host.stringValue),
                               port: remote_port.integerValue,
                               username: remote_username.stringValue,
                               remote_socket_path: remote_socket_location.stringValue,
                               local_socket_path: local
                               )
        let url: URL = tunnel.connect()
        print(tunnel, url)

        return url
    }
    
    @IBAction func revert_to_default_button(_ sender: Any) {
        socket_location.stringValue = default_socket_path
        revert_to_default_button.isEnabled = false
    }
    
    func show_existing_preferences() {
        switch prefs.node_location {
        case NodeLocation.local:
            local_button.state = NSControl.StateValue.on
        case NodeLocation.remote:
            remote_button.state = NSControl.StateValue.on
        }
        show_local_preferences()
        show_remote_preferences()

        change_node_location(self)
    }
    
    private func show_local_preferences() {
        socket_location.stringValue = local_prefs.socket_path
    }
    
    private func show_remote_preferences() {
        remote_host.stringValue = remote_prefs.host
        remote_port.integerValue = remote_prefs.port
        remote_username.stringValue = remote_prefs.username
        remote_socket_location.stringValue = remote_prefs.remote_socket_path
    }
    
    func save_preferences() {
        if local_button.state == NSControl.StateValue.on {
            prefs.node_location = NodeLocation.local
            save_local_preferences()
        } else {
            prefs.node_location = NodeLocation.remote
            save_remote_preferences()
        }
    }
    
    private func save_local_preferences() {
        local_prefs.socket_path = socket_location.stringValue
    }
    
    private func save_remote_preferences() {
        remote_prefs.host = remote_host.stringValue
        remote_prefs.port = remote_port.integerValue
        remote_prefs.username = remote_username.stringValue
        remote_prefs.remote_socket_path = remote_socket_location.stringValue
    }
    
    func test_local_connection() -> Bool {
        return test_connection(socket_path: socket_location.stringValue)
    }
    
    func test_connection(socket_path: String) -> Bool {
        guard let service = LightningRPCSocket(path: socket_path) else {
            connection_status.stringValue = "Disconnected"
            connection_status.textColor = NSColor.red
            
            return false
        }
        if (service.socket?.isConnected)! {
            _ = LightningRPCQuery(LightningRPC.Method.getinfo)
            connection_status.stringValue = "Connected"
            connection_status.textColor = NSColor.black
            
            return true
        } else {
            connection_status.stringValue = "Disconnected"
            connection_status.textColor = NSColor.red
        }
        
        return false
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        show_existing_preferences()
        socket_location.delegate = self
        revert_to_default_button.isEnabled = revert_to_default_button_should_be_active()
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        revert_to_default_button.isEnabled = revert_to_default_button_should_be_active()
    }
    
    func revert_to_default_button_should_be_active() -> Bool {
        if socket_location.stringValue == Constant.default_socket_path {
            return false
        }
        
        return true
    }
    
    func alert_socket_is_connected() {
        let alert = NSAlert()
        alert.messageText = "Connection Established"
        alert.informativeText = "Voltage is connected to the RPC socket"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Sweet!")
        alert.runModal()
    }
}
