//
//  PayInvoiceViewController.swift
//  Voltage
//
//  Created by Ben Harold on 7/19/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PayInvoiceViewController: NSViewController, NSPopoverDelegate, HandlesRPCErrors {

    let decoder: JSONDecoder = JSONDecoder.init()
    
    let bolt11_controller: Bolt11InvoiceWindowController = Bolt11InvoiceWindowController(windowNibName: NSNib.Name.bolt11_invoice)
    
    @IBOutlet weak var bolt11_field: NSTextField!
    
    @IBAction func decode_bolt11_button(_ sender: Any) {
        // TODO: validate_bolt11()
        if let bolt11: Bolt11Invoice = decode_bolt11() {
            bolt11_controller.showWindow(self)
            bolt11_controller.bolt11_value = bolt11_field.stringValue
            bolt11_controller.set_invoice_details(invoice: bolt11)
            PopoverManager.current?.close()
        }
    }
    
    func popoverWillShow(_ notification: Notification) {
        let popover = notification.object as? NSPopover
        popover?.behavior = .semitransient
        PopoverManager.current = popover
    }
    
    func decode_bolt11() -> Bolt11Invoice? {
        guard let socket = LightningRPCSocket.create() else { return nil }
        let query = LightningRPCQuery(method: LightningRPC.Method.decodepay, params: [bolt11_field.stringValue])
        let response: Data = socket.send(query)
        do {
            let result: Bolt11Invoice = try decoder.decode(Bolt11InvoiceResult.self, from: response).result
            return result
        } catch {
            if is_rpc_error(response: response) { return nil }
            print(response.to_string())
            print(error)
            return nil
        }
    }
    
}
