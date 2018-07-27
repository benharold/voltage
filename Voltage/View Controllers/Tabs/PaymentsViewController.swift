//
//  PaymentsViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//
// swiftlint:disable line_length

import Cocoa

class PaymentsViewController: VoltageTableViewController {
    
    var payment_list: [Payment] = [Payment]()
    
    let table_keys = [
        "id",
        "payment_hash",
        "destination",
        "msatoshi",
        "status",
        "created_at",
    ]
    
    @IBOutlet weak var payments_table_view: NSTableView!
    @IBOutlet weak var payment_hash: NSTextFieldCell!
    @IBOutlet weak var destination: NSTextFieldCell!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tab_index = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payments_table_view.delegate = self
        payments_table_view.dataSource = self
        set_sort_descriptors()
    }
    
    override func reload() {
        payment_list.removeAll()
        load_table_data()
        DispatchQueue.main.async {
            self.reload_table_view()
        }
    }
    
    override func load_table_data() {
        if let response: PaymentResult = query(LightningRPC.Method.listpayments) {
            payment_list = response.result.payments
        }
    }
    
    override func reload_table_view() {
        payments_table_view.reloadData()
    }
    
    func set_sort_descriptors() {
        for (index, _) in table_keys.enumerated() {
            payments_table_view.tableColumns[index].sortDescriptorPrototype = NSSortDescriptor(key: table_keys[index], ascending: true)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return payment_list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if payment_list.count == 0 {
            return nil
        }

        var key = ""
        key = tableColumn!.identifier.rawValue
        
        // There's got to be a better way. Maybe an enum or something?
        if key == "id" {
            return payment_list[row].id
        } else if key == "payment_hash" {
            return payment_list[row].payment_hash
        } else if key == "status" {
            return payment_list[row].status
        } else if key == "created" {
            return payment_list[row].created_at.to_date_string()
        } else if key == "msatoshi" {
            return payment_list[row].msatoshi / 1000
        } else if key == "destination" {
            return payment_list[row].destination
        }
        
        return nil
    }
    
    // This can probably be improved upon. See https://stackoverflow.com/questions/48511745/how-can-i-simplify-this-swift-sorting-code/48511962
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        let key = sortDescriptor.key!
        
        if sortDescriptor.ascending == true {
            switch key {
            case "payment_hash":
                payment_list.sort { $0.payment_hash < $1.payment_hash }
            case "destination":
                payment_list.sort { $0.destination < $1.destination }
            case "msatoshi":
                payment_list.sort { $0.msatoshi < $1.msatoshi }
            case "status":
                payment_list.sort { $0.status < $1.status }
            case "created_at":
                payment_list.sort { $0.created_at < $1.created_at }
            default:
                payment_list.sort { $0.id < $1.id }
            }
        } else {
            switch key {
            case "payment_hash":
                payment_list.sort { $0.payment_hash > $1.payment_hash }
            case "destination":
                payment_list.sort { $0.destination > $1.destination }
            case "msatoshi":
                payment_list.sort { $0.msatoshi > $1.msatoshi }
            case "status":
                payment_list.sort { $0.status > $1.status }
            case "created_at":
                payment_list.sort { $0.created_at > $1.created_at }
            default:
                payment_list.sort { $0.id > $1.id }
            }
        }
        
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        set_active_row()
    }
    
    func set_active_row() {
        if payments_table_view.selectedRow >= 0 {
            payment_hash.stringValue = payment_list[payments_table_view.selectedRow].payment_hash
            destination.stringValue = payment_list[payments_table_view.selectedRow].destination
        }
    }
}
