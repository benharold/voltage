//
//  Bolt11InvoiceWindowController.swift
//  Voltage
//
//  Created by Ben Harold on 7/18/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class Bolt11InvoiceWindowController: NSWindowController, HandlesRPCErrors {
    
    var bolt11_value: String?
    
    @IBOutlet weak var currency_field: NSTextField!
    @IBOutlet weak var created_at_field: NSTextField!
    @IBOutlet weak var expiry_field: NSTextField!
    @IBOutlet weak var payee_field: NSTextField!
    @IBOutlet weak var msatoshi_field: NSTextField!
    @IBOutlet weak var description_field: NSTextField!
    @IBOutlet weak var min_final_cltv_expiry_field: NSTextField!
    @IBOutlet weak var payment_hash_field: NSTextField!
    @IBOutlet weak var signature_field: NSTextField!
    
    @IBAction func pay_now_button(_ sender: Any) {
        // TODO: check expiration and available balance
        let query = LightningRPCQuery(LightningRPC.Method.pay, params: [bolt11_value!])
        print(query)
        guard let socket = LightningRPCSocket.create() else { return }
        let whatevs = socket.send(query)
        print(whatevs.to_string())
    }
    
    func set_invoice_details(invoice: Bolt11Invoice) {
        let expiration = invoice.created_at + invoice.expiry
        currency_field.stringValue = invoice.currency
        created_at_field.stringValue = invoice.created_at.to_date_string()
        expiry_field.stringValue = expiration.to_date_string()
        payee_field.stringValue = invoice.payee
        msatoshi_field.intValue = Int32(invoice.msatoshi)
        description_field.stringValue = invoice.description
        min_final_cltv_expiry_field.intValue = Int32(invoice.min_final_cltv_expiry)
        payment_hash_field.stringValue = invoice.payment_hash
        signature_field.stringValue = invoice.signature
    }
    
}
