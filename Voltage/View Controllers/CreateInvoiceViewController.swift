//
//  CreateInvoiceViewController.swift
//  Voltage
//
//  Created by Ben Harold on 7/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//
//  swiftlint:disable force_cast

import Cocoa

class CreateInvoiceViewController: NSViewController, NSPopoverDelegate {
    
    let decoder = JSONDecoder.init()
    
    var popover: NSPopover?
    
    lazy var invoice_view_controller: InvoiceViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "invoice_view_controller"))
            as! InvoiceViewController
    }()

    @IBOutlet weak var invoice_amount: NSTextField!
    @IBOutlet weak var invoice_label: NSTextField!
    @IBOutlet weak var invoice_description: NSTextField!
    @IBOutlet weak var invoice_expiry: NSDatePicker!
    @IBOutlet weak var invoice_preimage: NSTextField!
    @IBOutlet weak var invoice_denomination: NSPopUpButton!
    
    @IBAction func create_invoice_button(_ sender: Any) {
        if validate_input() {
            create_invoice()
        }
    }
    
    func popoverWillShow(_ notification: Notification) {
        invoice_amount.formatter = IntegerFormatter()
        
        // Set the default invoice expiration to 60 minutes
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 60, to: Date())
        invoice_expiry.dateValue = date!
        
        // Don't close the popover when a validaton alert is shown
        popover = notification.object as? NSPopover
        popover?.behavior = .semitransient
    }
    
    func create_invoice() {
        // interface hard-coded to satoshis for now
        let amount = String(invoice_amount.intValue * 1000)
        let label = invoice_label.stringValue
        let description = invoice_description.stringValue
        let start_date = Date()
        let end_date = invoice_expiry.dateValue
        let interval = DateInterval(start: start_date, end: end_date)
        let duration = String(Int(interval.duration))
        let preimage = invoice_preimage.stringValue
        var params = [amount, label, description, duration]
        if preimage != "" {
            params.append(preimage)
        }
        guard let socket = LightningRPCSocket.create() else {
            return
        }
        let createinvoice = LightningRPCQuery(id: Int(getpid()), method: "invoice", params: params)
        let response: Data = socket.send(query: createinvoice)
        do {
            let json_error = try? decoder.decode(ErrorResult.self, from: response).error
            if let error = json_error {
                NotificationCenter.default.post(name: Notification.Name.rpc_error, object: error)
            } else {
                var result: CreatedInvoice = try decoder.decode(CreatedInvoiceResult.self, from: response).result
                result.label = label
                self.display_invoice(sender: self, created_invoice: result)
            }
        } catch let error as Swift.DecodingError {
            NotificationCenter.default.post(name: Notification.Name.rpc_error, object: error)
        } catch {
            print("unknown error", error)
        }
    }
    
    func display_invoice(sender: AnyObject, created_invoice: CreatedInvoice) {
        popover?.close()
        self.presentViewControllerAsModalWindow(invoice_view_controller)
        invoice_view_controller.set_created(invoice: created_invoice)
    }

    func validate_input() -> Bool {
        if invoice_amount.intValue == 0 {
            alert_validation_failed(header: "Error", body: "\"Amount\" must be more than zero satoshis.")
            invoice_amount.becomeFirstResponder()
            return false
        }
        if invoice_label.stringValue == "" {
            alert_validation_failed(header: "Error", body: "A unique label is required.")
            invoice_label.becomeFirstResponder()
            return false
        }
        if invoice_description.stringValue == "" {
            alert_validation_failed(header: "Error", body: "A description is required.")
            invoice_description.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func alert_validation_failed(header: String, body: String) {
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Okay")
        
        alert.runModal()
    }
}
