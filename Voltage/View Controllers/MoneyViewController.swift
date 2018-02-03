//
//  MoneyViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class MoneyViewController: NSViewController {
    var output_list: [Output] = []
    
    var wallet_balance: Int = 0
    
    var decoder: JSONDecoder = JSONDecoder.init()

    @IBOutlet weak var wallet_balance_field: NSTextFieldCell!
    
    @IBOutlet weak var balance_bits: NSTextFieldCell!
    
    @IBOutlet weak var balance_µbtc: NSTextFieldCell!
    
    @IBOutlet weak var balance_btc: NSButton!
    
    @IBAction func get_money_button(_ sender: Any) {
    }
    
    @IBAction func spend_money_button(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_outputs()
    }
    
    func calculate_wallat_balance() {
        wallet_balance = 0
        for output in output_list {
            wallet_balance += output.value
        }
        wallet_balance_field.intValue = Int32(wallet_balance)
        balance_bits.objectValue = Int32(wallet_balance / 100)
        balance_µbtc.objectValue = Int32(wallet_balance / 100000)
        balance_btc.objectValue = (wallet_balance / 10000000)
        print("wallat balance", wallet_balance / 10000000)
    }
    
    func load_outputs() {
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let listoutputs: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listfunds", params: [])
        let response: Data = service.send(query: listoutputs)
        do {
            let result: OutputList = try decoder.decode(OutputResult.self, from: response).result
            output_list = result.outputs
        } catch {
            do {
                let error_message = try decoder.decode(ErrorResult.self, from: response).error
                print("RPC error: " + error_message)
            } catch {
                print("RPC error: \(error)")
            }
            //alert(message: "There was an error decoding the list of outputs. Is your c-lightning node running?")
            print("MoneyViewController::load_outputs() JSON decoder error: \(error)")
        }
        calculate_wallat_balance()
    }
}
