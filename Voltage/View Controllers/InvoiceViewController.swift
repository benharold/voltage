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
    @IBOutlet weak var lower_fields: NSView!
    @IBOutlet weak var y_constraint: NSLayoutConstraint!
    
    func display(sender: AnyObject) {
        self.presentViewControllerAsSheet(invoice_view_controller)
    }
    
    func set_created(invoice: CreatedInvoice) {
        hide_lower_fields()
        self.payment_hash.stringValue = invoice.payment_hash
        expires.stringValue = invoice.expiry_time.to_date_string()
        bolt_11.stringValue = invoice.bolt11
        if let label: String = invoice.label {
            self.title = label
        }
    }
    
    func set_existing(invoice: Invoice) {
        show_lower_fields()
        self.title = invoice.label
        payment_hash.stringValue = invoice.payment_hash
        if let bolt11: String = invoice.bolt12 {
            show_bolt_11()
            bolt_11.stringValue = bolt11
        } else {
            hide_bolt_11()
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
    
    func hide_bolt_11() {
        bolt_11.isHidden = true
        bolt_11_label.isHidden = true
        y_constraint.constant = 50
    }
    
    func show_bolt_11() {
        bolt_11.isHidden = false
        bolt_11_label.isHidden = false
        y_constraint.constant = 110
    }
    
    func hide_lower_fields() {
        show_bolt_11()
        lower_fields.isHidden = true
    }
    
    func show_lower_fields() {
        lower_fields.isHidden = false
    }
}
