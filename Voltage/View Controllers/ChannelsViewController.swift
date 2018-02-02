//
//  ChannelsViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class ChannelsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var channel_list: [Channel]!
    
    var decoder: JSONDecoder = JSONDecoder.init()
    
    @IBOutlet weak var channels_table_view: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        load_channels()
        
        channels_table_view.delegate = self
        channels_table_view.dataSource = self
    }
    
    func load_channels() {
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let listchannels: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listchannels", params: [])
        let response: Data = service.send(query: listchannels)
        do {
            let result: ChannelList = try decoder.decode(ChannelResult.self, from: response).result
            channel_list = result.channels
        } catch {
            print("ViewController::load_channels() JSON decoder error: \(error)")
        }
        
        channels_table_view.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return channel_list?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var key = ""
        key = tableColumn!.identifier.rawValue
        
        if key == "short_channel_id" {
            return channel_list[row].short_channel_id
        } else if key == "base_fee" {
            if channel_list[row].base_fee_millisatoshi != nil {
                return channel_list[row].base_fee_millisatoshi! / 1000
            }
            return 0
        } else if key == "flags" {
            return channel_list[row].flags
        } else if key == "active" {
            return channel_list[row].active.to_yes_no()
        } else if key == "last_update" {
            if channel_list[row].last_update != nil {
                let date = Date(timeIntervalSince1970: TimeInterval(channel_list[row].last_update!))
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .medium
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = NSLocale.current
                let strDate = dateFormatter.string(from: date)
                return strDate
            }
            return ""
        } else if key == "public" {
            return channel_list[row].`public`.to_yes_no()
        } else if key == "delay" {
            return channel_list[row].delay
        }
        
        return nil
    }
    
    // This can probably be improved upon. See https://stackoverflow.com/questions/48511745/how-can-i-simplify-this-swift-sorting-code/48511962
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        let key = sortDescriptor.key!
        
//        if sortDescriptor.ascending == true {
//            switch key {
//            case "flags":
//                channel_list.sort { $0.flags < $1.flags }
//            case "active":
//                channel_list.sort { $0.active < $1.active }
//            case "public":
//                channel_list.sort { $0.`public` < $1.`public` }
//            case "last_update":
//                channel_list.sort { $0.last_update < $1.last_update }
//            case "delay":
//                channel_list.sort { $0.delay < $1.delay }
//            default:
//                channel_list.sort { $0.short_channel_id < $1.short_channel_id }
//            }
//        } else {
//            switch key {
//            case "flags":
//                channel_list.sort { $0.flags > $1.flags }
//            case "active":
//                channel_list.sort { $0.active > $1.active }
//            case "public":
//                channel_list.sort { $0.`public` > $1.`public` }
//            case "updated":
//                channel_list.sort { $0.updated > $1.updated }
//            case "delay":
//                channel_list.sort { $0.delay > $1.delay }
//            default:
//                channel_list.sort { $0.short_channel_id > $1.short_channel_id }
//            }
//        }
        
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        set_active_row()
    }
    
    func set_active_row() {
        // channels_table_view.selectedRow will be -1 if the user selects a column
        if channels_table_view.selectedRow >= 0 {
//            channel_hash.stringValue = channel_list[channels_table_view.selectedRow].channel_hash
//            destination.stringValue = channel_list[channels_table_view.selectedRow].destination
        }
    }
    
}
