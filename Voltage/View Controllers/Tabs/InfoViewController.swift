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
        load_info()
    }
    
    func load_info() {
        guard let service = LightningRPCSocket.create() else { return }
        let query = LightningRPCQuery(LightningRPC.Method.getinfo)
        let response: Data = service.send(query)
        do {
            let result: GetInfo = try decoder.decode(GetInfoResult.self, from: response).result
            DispatchQueue.main.async {
                self.node_id.stringValue = result.id
                self.port.stringValue = String(result.port)
                self.version.stringValue = result.version
                self.block_height.intValue = Int32(result.blockheight)
                self.network.stringValue = result.network
            }
        } catch {
            if is_rpc_error(response: response) { return }
            print("InfoViewController.load_info() JSON decoder error: \(error)")
        }
    }
}
