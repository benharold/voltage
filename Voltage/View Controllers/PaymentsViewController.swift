//
//  PaymentsViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/1/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PaymentsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var payment_list: [Payment]!
    
    var decoder: JSONDecoder = JSONDecoder.init()
    
    @IBOutlet weak var payments_table_view: NSTableView!
    
    @IBOutlet weak var payment_hash: NSTextFieldCell!
    
    @IBOutlet weak var destination: NSTextFieldCell!
    
    @IBAction func reload_button(_ sender: Any) {
        load_payments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_payments()
        
        //for _ in 1...5 {
        //    payment_list.append(Payment.fake())
        //}
        //print(payment_list)

        payments_table_view.delegate = self
        payments_table_view.dataSource = self
        payments_table_view.tableColumns[0].sortDescriptorPrototype = NSSortDescriptor(key: "id", ascending: true)
        payments_table_view.tableColumns[1].sortDescriptorPrototype = NSSortDescriptor(key: "payment_hash", ascending: true)
        payments_table_view.tableColumns[2].sortDescriptorPrototype = NSSortDescriptor(key: "destination", ascending: true)
        payments_table_view.tableColumns[3].sortDescriptorPrototype = NSSortDescriptor(key: "msatoshi", ascending: true)
        payments_table_view.tableColumns[4].sortDescriptorPrototype = NSSortDescriptor(key: "status", ascending: true)
        payments_table_view.tableColumns[5].sortDescriptorPrototype = NSSortDescriptor(key: "created_at", ascending: true)
    }
    
    func load_payments() {
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let listpayments: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listpayments", params: [])
        let response: Data = service.send(query: listpayments)
        do {
            let result: PaymentList = try decoder.decode(PaymentResult.self, from: response).result
            payment_list = result.payments
        } catch {
            //alert(message: "There was an error decoding the list of payments. Is your c-lightning node running?")
            print("ViewController::load_payments() JSON decoder error: \(error)")
        }
        
        payments_table_view.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return payment_list?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
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
            let date = Date(timeIntervalSince1970: TimeInterval(payment_list[row].created_at))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale.current
            //dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: date)
            return strDate
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
        // payments_table_view.selectedRow will be -1 if the user selects a column
        if payments_table_view.selectedRow >= 0 {
            payment_hash.stringValue = payment_list[payments_table_view.selectedRow].payment_hash
            destination.stringValue = payment_list[payments_table_view.selectedRow].destination
        }
    }
}
