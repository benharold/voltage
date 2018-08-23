//
//  InvoicesViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//
// swiftlint:disable force_cast

import Cocoa

class InvoicesViewController: VoltageTableViewController {
    
    var invoice_list: [Invoice] = [Invoice]()
    
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
    
    lazy var invoice_view_controller: InvoiceViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "invoice_view_controller")) as! InvoiceViewController
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tab_index = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        invoices_table_view.delegate = self
        invoices_table_view.dataSource = self
        invoices_table_view.target = self
        invoices_table_view.doubleAction = #selector(double_click(_:))
        set_sort_descriptors()
    }
    
    override func reload() {
        invoice_list.removeAll()
        load_table()
    }
    
    @objc func double_click(_ sender: NSTableView) {
        self.presentViewControllerAsModalWindow(invoice_view_controller)
        invoice_view_controller.set_existing(invoice: invoice_list[sender.clickedRow])
    }

    override func load_table_data() {
        if let response: InvoiceResult = query(LightningRPC.Method.listinvoices) {
            invoice_list = response.result.invoices
        }
    }
    
    override func reload_table_view() {
        invoices_table_view.reloadData()
    }
    
    func set_sort_descriptors() {
        for (index, _) in table_keys.enumerated() {
            invoices_table_view.tableColumns[index].sortDescriptorPrototype = NSSortDescriptor(key: table_keys[index], ascending: true)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return invoice_list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if invoice_list.count == 0 {
            return nil
        }
        
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
            return invoice_list[row].paid_at?.to_date_string()
        } else if key == "expires_at" {
            return invoice_list[row].expires_at.to_date_string()
        }
        
        return nil
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
}
