//
//  InvoicesViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class InvoicesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var invoice_list: [Invoice]!
    
    var decoder: JSONDecoder = JSONDecoder.init()
    
    @IBOutlet weak var invoices_table_view: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_invoices()
        
        invoices_table_view.delegate = self
        invoices_table_view.dataSource = self
    }
    
    func load_invoices() {
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let listinvoices: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listinvoices", params: [])
        let response: Data = service.send(query: listinvoices)
        do {
            let result: InvoiceList = try decoder.decode(InvoiceResult.self, from: response).result
            invoice_list = result.invoices
        } catch {
            print("ViewController::load_invoices() JSON decoder error: \(error)")
        }
        
        invoices_table_view.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return invoice_list?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var key = ""
        key = tableColumn!.identifier.rawValue

        let msatoshi_received = invoice_list[row].msatoshi_received ?? 0
        
        if key == "label" {
            return invoice_list[row].label
        } else if key == "status" {
            return invoice_list[row].status
        } else if key == "billed" {
            return invoice_list[row].msatoshi / 1000
        } else if key == "pay_index" {
            return invoice_list[row].pay_index
        } else if key == "paid" {
            return msatoshi_received / 1000
        } else if key == "paid_at" {
            return pretty_date(timestamp: invoice_list[row].paid_at)
        } else if key == "expires_at" {
            return pretty_date(timestamp: invoice_list[row].expires_at)
        }
        
//        if key == "short_invoice_id" {
//            return invoice_list[row].short_invoice_id
//        } else if key == "base_fee" {
//            if invoice_list[row].base_fee_millisatoshi != nil {
//                return invoice_list[row].base_fee_millisatoshi! / 1000
//            }
//            return 0
//        } else if key == "flags" {
//            return invoice_list[row].flags
//        } else if key == "active" {
//            return invoice_list[row].active.to_yes_no()
//        } else if key == "last_update" {
//            if invoice_list[row].last_update != nil {
//                let date = Date(timeIntervalSince1970: TimeInterval(invoice_list[row].last_update!))
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .medium
//                dateFormatter.timeStyle = .medium
//                dateFormatter.timeZone = TimeZone.current
//                dateFormatter.locale = NSLocale.current
//                let strDate = dateFormatter.string(from: date)
//                return strDate
//            }
//            return ""
//        } else if key == "public" {
//            return invoice_list[row].`public`.to_yes_no()
//        } else if key == "delay" {
//            return invoice_list[row].delay
//        }
        
        return nil
    }
    
    func pretty_date(timestamp: Int?) -> String {
        if timestamp == nil {
            return "N/A"
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        
        return dateFormatter.string(from: date)
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
        //                invoice_list.sort { $0.flags < $1.flags }
        //            case "active":
        //                invoice_list.sort { $0.active < $1.active }
        //            case "public":
        //                invoice_list.sort { $0.`public` < $1.`public` }
        //            case "last_update":
        //                invoice_list.sort { $0.last_update < $1.last_update }
        //            case "delay":
        //                invoice_list.sort { $0.delay < $1.delay }
        //            default:
        //                invoice_list.sort { $0.short_invoice_id < $1.short_invoice_id }
        //            }
        //        } else {
        //            switch key {
        //            case "flags":
        //                invoice_list.sort { $0.flags > $1.flags }
        //            case "active":
        //                invoice_list.sort { $0.active > $1.active }
        //            case "public":
        //                invoice_list.sort { $0.`public` > $1.`public` }
        //            case "updated":
        //                invoice_list.sort { $0.updated > $1.updated }
        //            case "delay":
        //                invoice_list.sort { $0.delay > $1.delay }
        //            default:
        //                invoice_list.sort { $0.short_invoice_id > $1.short_invoice_id }
        //            }
        //        }
        
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        set_active_row()
    }
    
    func set_active_row() {
        // invoices_table_view.selectedRow will be -1 if the user selects a column
        if invoices_table_view.selectedRow >= 0 {
            //            invoice_hash.stringValue = invoice_list[invoices_table_view.selectedRow].invoice_hash
            //            destination.stringValue = invoice_list[invoices_table_view.selectedRow].destination
        }
    }
}
