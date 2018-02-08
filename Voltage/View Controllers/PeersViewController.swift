//
//  PeersViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/5/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PeersViewController: VoltageTableViewController, NSTableViewDelegate, NSTableViewDataSource {

    var peer_list: [Peer]!
    
    @IBOutlet weak var peers_table_view: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peers_table_view.delegate = self
        peers_table_view.dataSource = self
    }
    
    override func load_table_data() {
        load_peers()
    }
    
    override func reload_table_view() {
        peers_table_view.reloadData()
    }

    func load_peers() {
        let listpeers: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listpeers", params: [])
        let response: Data = socket.send(query: listpeers)
        do {
            let result: PeerList = try decoder.decode(PeerResult.self, from: response).result
            peer_list = result.peers
        } catch {
            print("ViewController::load_peers() JSON decoder error: \(error)")
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return peer_list?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var key = ""
        key = tableColumn!.identifier.rawValue
        
        if key == "id" {
            return peer_list[row].id
        } else if key == "connected" {
            return peer_list[row].connected.to_yes_no()
        } else if key == "state" {
            return peer_list[row].channels?[0].state ?? ""
        } else if key == "owner" {
            return peer_list[row].channels?[0].owner ?? ""
        } else if key == "dust_limit_satoshis" {
            return peer_list[row].channels?[0].dust_limit_satoshis ?? ""
        }
 
        return ""
    }
    
}
