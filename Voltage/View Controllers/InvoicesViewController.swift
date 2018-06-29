//
//  InvoicesViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class InvoicesViewController: VoltageTableViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    var invoice_list: [Invoice]!
    
    let table_keys = [
        "label",
        "status",
        "msatoshi",
        "msatoshi_received",
        "pay_index",
        "paid_at",
        "expires_at",
    ]
    
    @IBOutlet weak var invoices_table_view: NSTableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tab_index = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        invoices_table_view.delegate = self
        invoices_table_view.dataSource = self
        set_sort_descriptors()
    }
    
    override func reload() {
        if invoice_list != nil {
            invoice_list.removeAll()
        }
        load_table_data()
        DispatchQueue.main.async {
            self.reload_table_view()
        }
    }

    override func load_table_data() {
        load_invoices()
    }
    
    override func reload_table_view() {
        invoices_table_view.reloadData()
    }
    
    func set_sort_descriptors() {
        for (index, _) in table_keys.enumerated() {
            invoices_table_view.tableColumns[index].sortDescriptorPrototype = NSSortDescriptor(key: table_keys[index], ascending: true)
        }
    }
    
    func load_invoices() {
        let listinvoices: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listinvoices", params: [])
        guard let socket = LightningRPCSocket.create() else {
            return
        }
        let response: Data = socket.send(query: listinvoices)
        do {
            let result: InvoiceList = try decoder.decode(InvoiceResult.self, from: response).result
            invoice_list = result.invoices
        } catch {
            print("ViewController::load_invoices() JSON decoder error: \(error)")
        }
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
        } else if key == "msatoshi" {
            return invoice_list[row].msatoshi / 1000
        } else if key == "pay_index" {
            return invoice_list[row].pay_index
        } else if key == "msatoshi_received" {
            return msatoshi_received / 1000
        } else if key == "paid_at" {
            return pretty_date(timestamp: invoice_list[row].paid_at)
        } else if key == "expires_at" {
            return pretty_date(timestamp: invoice_list[row].expires_at)
        }
        
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
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        let key = sortDescriptor.key!
        
        if sortDescriptor.ascending == true {
            switch key {
            case "label":
                invoice_list.sort { $0.label < $1.label }
            case "msatoshi":
                invoice_list.sort { $0.msatoshi < $1.msatoshi }
            case "status":
                invoice_list.sort { $0.status < $1.status }
            case "pay_index":
                invoice_list.sort { Int($0.pay_index ?? -1) < Int($1.pay_index ?? -1) }
            case "msatoshi_received":
                invoice_list.sort { Int($0.msatoshi_received ?? -1) < Int($1.msatoshi_received ?? -1) }
            case "paid_at":
                invoice_list.sort { Int($0.paid_at ?? -1) < Int($1.paid_at ?? -1) }
            default:
                invoice_list.sort { $0.expires_at < $1.expires_at }
            }
        } else {
            switch key {
            case "label":
                invoice_list.sort { $0.label > $1.label }
            case "msatoshi":
                invoice_list.sort { $0.msatoshi > $1.msatoshi }
            case "status":
                invoice_list.sort { $0.status > $1.status }
            case "pay_index":
                invoice_list.sort { Int($0.pay_index ?? -1) > Int($1.pay_index ?? -1) }
            case "msatoshi_received":
                invoice_list.sort { Int($0.msatoshi_received ?? -1) > Int($1.msatoshi_received ?? -1) }
            case "paid_at":
                invoice_list.sort { Int($0.paid_at ?? -1) > Int($1.paid_at ?? -1) }
            default:
                invoice_list.sort { $0.expires_at > $1.expires_at }
            }
        }

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
