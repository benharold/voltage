//
//  SendMoneyViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class SendMoneyViewController: NSViewController, HandlesRPCErrors {

    @IBOutlet weak var send_to_field: NSTextField!
    
    @IBOutlet weak var amount_field: NSTextField!
    
    @IBAction func send_button(_ sender: Any) {
        send_money()
    }
    
    func send_money() {
        let amount = amount_field.stringValue
        let address = send_to_field.stringValue
        let decoder: JSONDecoder = JSONDecoder.init()
        guard let service = LightningRPCSocket.create() else {
            return
        }
        let query = LightningRPCQuery(method: LightningRPC.Method.withdraw, params: [address, amount])
        let response: Data = service.send(query)
        print(response.to_string())
        do {
            let result: Withdraw = try decoder.decode(WithdrawResult.self, from: response).result
            print(result)
            // TODO: something with the result
        } catch {
            if is_rpc_error(response: response) { return }
            print("SendMoneyViewController.send_money() JSON decoder error: \(error)")
        }
    }
    
}
