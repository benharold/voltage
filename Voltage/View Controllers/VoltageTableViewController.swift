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
class VoltageTableViewController: ReloadableViewController, VoltageTableView {

    let decoder: JSONDecoder = JSONDecoder.init()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loading_start"), object: nil)
        load_table()
    }
    
    func load_table_data() {
    }
    
    func reload_table_view() {
    }
    
    func load_table() {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.load_table_data()
            DispatchQueue.main.async {
                self.reload_table_view()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loading_finish"), object: nil)
        }
    }
    
}
