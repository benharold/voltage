//
//  LightningRPCConstants.swift
//  Voltage
//
//  Created by Ben Harold on 2/4/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct LightningRPCConstants {
    struct LightningRPCMethods {
        let dev_blockheight: String = "dev-blockheight"
        let dev_setfees: String = "dev-setfees"
        let listnodes: String = "listnodes"
        let getroute: String = "getroute"
        let listchannels: String = "listchannels"
        let invoice: String = "invoice"
        let listinvoice: String = "listinvoice"
        let listinvoices: String = "listinvoices"
        let delinvoice: String = "delinvoice"
        let waitanyinvoice: String = "waitanyinvoice"
        let waitinvoice: String = "waitinvoice"
        let decodepay: String = "decodepay"
        let help: String = "help"
        let stop: String = "stop"
        let getlog: String = "getlog"
        let dev_rhash: String = "dev-rhash"
        let dev_crash: String = "dev-crash"
        let getinfo: String = "getinfo"
        let sendpay: String = "sendpay"
        let pay: String = "pay"
        let listpayments: String = "listpayments"
        let connect: String = "connect"
        let listpeers: String = "listpeers"
        let fundchannel: String = "fundchannel"
        let close: String = "close"
        let dev_sign_last_tx: String = "dev-sign-last-tx"
        let dev_fail: String = "dev-fail"
        let dev_reenable_commit: String = "dev-reenable-commit"
        let dev_ping: String = "dev-ping"
        let dev_memdump: String = "dev-memdump"
        let dev_memleak: String = "dev-memleak"
        let withdraw: String = "withdraw"
        let newaddr: String = "newaddr"
        let listfunds: String = "listfunds"
    }
    
    struct LightningRPCArguments {
        let required: [String: String]
        let optional: [String: String]
    }
}
