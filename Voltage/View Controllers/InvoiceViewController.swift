//
//  InvoiceViewController.swift
//  Voltage
//
//  Created by Ben Harold on 7/6/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//
//  swiftlint:disable force_cast

import Cocoa

class InvoiceViewController: NSViewController {
    
    var created: CreatedInvoice?
    
    var existing: Invoice?
    
    lazy var invoice_view_controller: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "invoice_view_controller"))
            as! NSViewController
    }()
    
    @IBOutlet weak var payment_hash: NSTextField!
    @IBOutlet weak var expires: NSTextField!
    @IBOutlet weak var bolt_11_label: NSTextField!
    @IBOutlet weak var bolt_11: NSTextField!
    @IBOutlet weak var msatoshi: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var pay_index: NSTextField!
    @IBOutlet weak var msatoshi_received: NSTextField!
    @IBOutlet weak var paid_at: NSTextField!

    func display(sender: AnyObject) {
        self.presentViewControllerAsSheet(invoice_view_controller)
    }
    
    func set_created(invoice: CreatedInvoice) {
        self.payment_hash.stringValue = invoice.payment_hash
        expires.stringValue = invoice.expiry_time.to_date_string()
        bolt_11.stringValue = invoice.bolt11
    }
    
    func set_existing(invoice: Invoice) {
        print(invoice)
        self.title = invoice.label
        payment_hash.stringValue = invoice.payment_hash
        if let bolt11: String = invoice.bolt11 {
            bolt_11.stringValue = bolt11
        } else {
            bolt_11.stringValue = ""
        }
        msatoshi.intValue = Int32(invoice.msatoshi)
        status.stringValue = invoice.status
        if let index = invoice.pay_index {
            pay_index.intValue = Int32(index)
        } else {
            pay_index.stringValue = ""
        }
        if let received = invoice.msatoshi_received {
            msatoshi_received.intValue = Int32(received)
        } else {
            msatoshi_received.stringValue = ""
        }
        if let paid: Int = invoice.paid_at {
            paid_at.stringValue = paid.to_date_string()
        } else {
            paid_at.stringValue = "N/A"
        }
        expires.stringValue = invoice.expires_at.to_date_string()

        print("done")
    }
}
