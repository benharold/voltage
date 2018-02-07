//
//  LightningRPC.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class LightningRPC: NSObject {
    var method: String
    
    let valid_methods: [String] = [
        "dev-blockheight",
        "dev-setfees",
        "listnodes",
        "getroute",
        "listchannels",
        "invoice",
        "listinvoice",
        "listinvoices",
        "delinvoice",
        "waitanyinvoice",
        "waitinvoice",
        "decodepay",
        "help",
        "stop",
        "getlog",
        "dev-rhash",
        "dev-crash",
        "getinfo",
        "sendpay",
        "pay",
        "listpayments",
        "connect",
        "listpeers",
        "fundchannel",
        "close",
        "dev-sign-last-tx",
        "dev-fail",
        "dev-reenable-commit",
        "dev-ping",
        "dev-memdump",
        "dev-memleak",
        "withdraw",
        "newaddr",
        "listfunds"
    ]
    
    init?(method: String) {
        if valid_methods.contains(method) {
            self.method = method
        } else {
            return nil
        }
    }
}
