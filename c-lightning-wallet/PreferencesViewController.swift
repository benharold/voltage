//
//  PreferencesViewController.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    var preferences = Preferences()
    
    @IBOutlet weak var socket_location: NSTextFieldCell!
    
    @IBAction func save_button(_ sender: Any) {
        save_preferences()
        view.window?.close()
    }
    
    @IBAction func cancel_button(_ sender: Any) {
        view.window?.close()
    }
    
    func show_existing_preferences() {
        socket_location.stringValue = preferences.socket_path
    }
    
    func save_preferences() {
        preferences.socket_path = socket_location.stringValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show_existing_preferences()
    }
}
