//
//  PeersViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/5/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

// Peers are a bit different than the other basic list view controllers because
// a Peer has an optional nested PeerChannel object which is not analogous to
// a Channel object. Further muddying the waters, both the Peer and PeerChannel
// object contain an optional `owner` field, while the `state` field is
// required for a PeerChannel and optional for a peer.
class PeersViewController: VoltageTableViewController {

    var peer_list: [Peer] = [Peer]()
    
    let table_keys = [
        "id",
        "connected",
        "state",
        "owner",
        "dust_limit_satoshis",
        "netaddr",
    ]
    
    @IBOutlet weak var peers_table_view: NSTableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tab_index = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peers_table_view.delegate = self
        peers_table_view.dataSource = self
        set_sort_descriptors()
    }
    
    override func reload() {
        peer_list.removeAll()
        load_table_data()
        DispatchQueue.main.async {
            self.reload_table_view()
        }
    }
    
    override func load_table_data() {
        load_peers()
    }
    
    override func reload_table_view() {
        peers_table_view.reloadData()
    }
    
    func set_sort_descriptors() {
        for (index, _) in table_keys.enumerated() {
            peers_table_view.tableColumns[index].sortDescriptorPrototype = NSSortDescriptor(key: table_keys[index], ascending: true)
        }
    }

    func load_peers() {
        let listpeers: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listpeers", params: [])
        guard let socket = LightningRPCSocket.create() else {
            return
        }
        let response: Data = socket.send(query: listpeers)
        do {
            let result: PeerList = try decoder.decode(PeerResult.self, from: response).result
            peer_list = result.peers
        } catch {
            print("ViewController::load_peers() JSON decoder error: \(error)")
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return peer_list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if peer_list.count == 0 {
            return nil
        }
        
        var key = ""
        key = tableColumn!.identifier.rawValue
        
        if key == "id" {
            return peer_list[row].id
        } else if key == "netaddr" {
            return peer_list[row].netaddr?[0] ?? ""
        } else if key == "connected" {
            return peer_list[row].connected.to_yes_no()
        } else if key == "state" {
            if peer_list[row].state != nil {
                return peer_list[row].state
            }
            return peer_list[row].channels?[0].state ?? ""
        } else if key == "owner" {
            return peer_list[row].channels?[0].owner ?? ""
        } else if key == "dust_limit_satoshis" {
            return peer_list[row].channels?[0].dust_limit_satoshis ?? ""
        }
 
        return ""
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        let key = sortDescriptor.key!
        
        // I don't know why the `owner` column won't sort properly and I don't
        // have time to care right now.
        //
        // I really need to pull that `state` sorting function as well.
        if sortDescriptor.ascending == true {
            switch key {
            case "netaddr":
                peer_list.sort { $0.netaddr?[0] ?? "" < $1.netaddr?[0] ?? "" }
            case "connected":
                peer_list.sort { $0.connected && !$1.connected }
            case "state":
                peer_list.sort {
                    var zero_state: String
                    var one_state: String
                    if $0.state != nil {
                        zero_state = $0.state!
                    } else {
                        zero_state = $0.channels?[0].state ?? ""
                    }
                    
                    if $1.state != nil {
                        one_state = $1.state!
                    } else {
                        one_state = $1.channels?[0].state ?? ""
                    }
                    
                    return zero_state < one_state
                }
            case "owner":
                peer_list.sort { $0.owner ?? "" < $1.owner ?? "" }
            case "dust_limit_satoshis":
                peer_list.sort { Int($0.channels?[0].dust_limit_satoshis ?? -1) < Int($1.channels?[0].dust_limit_satoshis ?? -1) }
            default:
                peer_list.sort { $0.id < $1.id }
            }
        } else {
            switch key {
            case "netaddr":
                peer_list.sort { $0.netaddr?[0] ?? "" > $1.netaddr?[0] ?? "" }
            case "connected":
                peer_list.sort { !$0.connected && $1.connected }
            case "state":
                peer_list.sort {
                    var zero_state: String
                    var one_state: String
                    if $0.state != nil {
                        zero_state = $0.state!
                    } else {
                        zero_state = $0.channels?[0].state ?? ""
                    }
                    
                    if $1.state != nil {
                        one_state = $1.state!
                    } else {
                        one_state = $1.channels?[0].state ?? ""
                    }
                    
                    return zero_state > one_state
                }
            case "owner":
                peer_list.sort { $0.owner ?? "" > $1.owner ?? "" }
            case "dust_limit_satoshis":
                peer_list.sort { Int($0.channels?[0].dust_limit_satoshis ?? -1) > Int($1.channels?[0].dust_limit_satoshis ?? -1) }
            default:
                peer_list.sort { $0.id > $1.id }
            }
        }
        
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        set_active_row()
    }
    
    func set_active_row() {
        // payments_table_view.selectedRow will be -1 if the user selects a column
        if peers_table_view.selectedRow >= 0 {
            
        }
    }
}
