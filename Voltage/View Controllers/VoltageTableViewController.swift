//
//  VoltageTableViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/7/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

// The idea is to allow loading of table data in the background without
// interrupitng the UI. This is common to several tabs. The JSON decoder
// probably belongs in a different spot, as well as the socket. We'll get there.
class VoltageTableViewController: NSViewController, VoltageTableView {

    let decoder: JSONDecoder = JSONDecoder.init()
    
    let socket: LightningRPCSocket = LightningRPCSocket.create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_table()
    }
    
    func load_table_data() {
    }
    
    func reload_table_view() {
    }
    
    func load_table() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.load_table_data()
            
            DispatchQueue.main.async {
                self.reload_table_view()
            }
        }
    }
    
}
