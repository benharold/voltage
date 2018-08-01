//
//  SendMoneyViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class SendMoneyViewController: NSViewController, NSPopoverDelegate, HandlesRPCErrors {

    @IBOutlet weak var send_to_field: NSTextField!
    
    @IBOutlet weak var amount_field: NSTextField!
    
    @IBAction func send_button(_ sender: Any) {
        // TODO: add formatters, validate inputs
        send_money()
    }
    
    func popoverWillShow(_ notification: Notification) {
        PopoverManager.current = notification.object as? NSPopover
    }
    
    func send_money() {
        let amount = amount_field.stringValue
        let address = send_to_field.stringValue
        let decoder: JSONDecoder = JSONDecoder.init()
        guard let service = LightningRPCSocket.create() else {
            return
        }
        let query = LightningRPCQuery(LightningRPC.Method.withdraw, params: [address, amount])
        let response: Data = service.send(query)
        print(response.to_string())
        do {
            let result: Withdraw = try decoder.decode(WithdrawResult.self, from: response).result
            show_transaction_confirmation_message(transaction: result)
            reload_blockchain_balance()
        } catch {
            if is_rpc_error(response: response) { return }
            print("SendMoneyViewController.send_money() JSON decoder error: \(error)")
        }
    }
    
    func show_transaction_confirmation_message(transaction: Withdraw) {
        let alert = NSAlert()
        alert.messageText = "Transaction Broadcast"
        alert.informativeText = "Transaction ID: \(transaction.txid)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        
        alert.runModal()
    }
    
    func reload_blockchain_balance() {
        let reload = Notification(name: Notification.Name.reload)
        NotificationCenter.default.post(reload)
    }
    
}
