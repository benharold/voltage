//
//  LightningRPCConstants.swift
//  Voltage
//
//  Created by Ben Harold on 2/4/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct LightningRPC {
    struct Method {
        static let dev_blockheight: String = "dev-blockheight"
        static let dev_setfees: String = "dev-setfees"
        static let listnodes: String = "listnodes"
        static let getroute: String = "getroute"
        static let listchannels: String = "listchannels"
        static let invoice: String = "invoice"
        static let listinvoice: String = "listinvoice"
        static let listinvoices: String = "listinvoices"
        static let delinvoice: String = "delinvoice"
        static let waitanyinvoice: String = "waitanyinvoice"
        static let waitinvoice: String = "waitinvoice"
        static let decodepay: String = "decodepay"
        static let help: String = "help"
        static let stop: String = "stop"
        static let getlog: String = "getlog"
        static let dev_rhash: String = "dev-rhash"
        static let dev_crash: String = "dev-crash"
        static let getinfo: String = "getinfo"
        static let sendpay: String = "sendpay"
        static let pay: String = "pay"
        static let listpayments: String = "listpayments"
        static let connect: String = "connect"
        static let listpeers: String = "listpeers"
        static let fundchannel: String = "fundchannel"
        static let close: String = "close"
        static let dev_sign_last_tx: String = "dev-sign-last-tx"
        static let dev_fail: String = "dev-fail"
        static let dev_reenable_commit: String = "dev-reenable-commit"
        static let dev_ping: String = "dev-ping"
        static let dev_memdump: String = "dev-memdump"
        static let dev_memleak: String = "dev-memleak"
        static let withdraw: String = "withdraw"
        static let newaddr: String = "newaddr"
        static let listfunds: String = "listfunds"
    }
}
