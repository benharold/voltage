//
//  SendMoneyViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class SendMoneyViewController: NSViewController {

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
        let newaddr: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()),
                                                           method: "withdraw",
                                                           params: [address, amount])
        let response: Data = service.send(query: newaddr)
        print(response.to_string())
        do {
            let result: Withdraw = try decoder.decode(WithdrawResult.self, from: response).result
            print(result)
//            return result
        } catch {
            do {
                let rpc_error = try decoder.decode(ErrorResult.self, from: response).error
                print("SendMoneyViewController.send_money() RPC error: " + rpc_error.message)
            } catch {
                print("SendMoneyViewController.send_money() RPC error: \(error)")
            }
            print("SendMoneyViewController.send_money() JSON decoder error: \(error)")
        }
    }
    
}
