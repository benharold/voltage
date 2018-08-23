//
//  VoltageTableViewProtocol.swift
//  Voltage
//
//  Created by Ben Harold on 2/7/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

protocol VoltageTableView: NSTableViewDelegate, NSTableViewDataSource {
    func load_table_data()
    func reload_table_view()
    func load_table()
}
