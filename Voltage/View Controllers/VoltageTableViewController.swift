//
//  VoltageTableViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/7/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

// The idea is to allow loading of table data in the background without
// interrupitng the UI. This is common to several tabs.
class VoltageTableViewController: ReloadableViewController, VoltageTableView {

    func load_table_data() {
    }
    
    func reload_table_view() {
    }
    
    func load_table() {
        self.load_table_data()
        DispatchQueue.main.async {
            self.reload_table_view()
        }
    }
    
}
