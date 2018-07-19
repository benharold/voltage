//
//  LightningRPCConstants.swift
//  Voltage
//
//  Created by Ben Harold on 2/4/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct LightningRPC {
    enum Method: String {
        case dev_blockheight = "dev-blockheight"
        case dev_setfees = "dev-setfees"
        case listnodes = "listnodes"
        case getroute = "getroute"
        case listchannels = "listchannels"
        case invoice = "invoice"
        case listinvoice = "listinvoice"
        case listinvoices = "listinvoices"
        case delinvoice = "delinvoice"
        case waitanyinvoice = "waitanyinvoice"
        case waitinvoice = "waitinvoice"
        case decodepay = "decodepay"
        case help = "help"
        case stop = "stop"
        case getlog = "getlog"
        case dev_rhash = "dev-rhash"
        case dev_crash = "dev-crash"
        case getinfo = "getinfo"
        case sendpay = "sendpay"
        case pay = "pay"
        case listpayments = "listpayments"
        case connect = "connect"
        case listpeers = "listpeers"
        case fundchannel = "fundchannel"
        case close = "close"
        case dev_sign_last_tx = "dev-sign-last-tx"
        case dev_fail = "dev-fail"
        case dev_reenable_commit = "dev-reenable-commit"
        case dev_ping = "dev-ping"
        case dev_memdump = "dev-memdump"
        case dev_memleak = "dev-memleak"
        case withdraw = "withdraw"
        case newaddr = "newaddr"
        case listfunds = "listfunds"
    }
}
