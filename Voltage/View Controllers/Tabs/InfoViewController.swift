//
//  InfoViewController.swift
//  Voltage
//
//  Created by Ben Harold on 6/18/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class InfoViewController: ReloadableViewController {
    
    var decoder: JSONDecoder = JSONDecoder.init()
    
    @IBOutlet weak var node_id: NSTextField!
    @IBOutlet weak var port: NSTextField!
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var block_height: NSTextField!
    @IBOutlet weak var network: NSTextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tab_index = 5
    }
    
    override func reload() {
        if let response: GetInfoResult = query(LightningRPC.Method.getinfo) {
            set_interface_values(response.result)
        }
    }
    
    func set_interface_values(_ data: GetInfo) {
        DispatchQueue.main.async {
            self.node_id.stringValue = data.id
            self.port.stringValue = String(data.port)
            self.version.stringValue = data.version
            self.block_height.intValue = Int32(data.blockheight)
            self.network.stringValue = data.network
        }
    }
}
