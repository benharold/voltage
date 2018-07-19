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
        case connect = "connect"
        case listnodes = "listnodes"
        case getroute = "getroute"
        case listchannels = "listchannels"
        case invoice = "invoice"
        // case listinvoice = "listinvoice"
        case listinvoices = "listinvoices"
        case delinvoice = "delinvoice"
        case delexpiredinvoice = "delexpiredinvoice"
        case autocleaninvoice = "autocleaninvoice"
        case waitanyinvoice = "waitanyinvoice"
        case waitinvoice = "waitinvoice"
        case decodepay = "decodepay"
        case help = "help"
        case stop = "stop"
        case getinfo = "getinfo"
        case getlog = "getlog"
        case fundchannel = "fundchannel"
        case listconfigs = "listconfigs"
        case sendpay = "sendpay"
        case waitsendpay = "waitsendpay"
        case listpayments = "listpayments"
        case pay = "pay"
        case listpeers = "listpeers"
        case close = "close"
        case disconnect = "disconnect"
        case dev_ping = "dev-ping"
        case withdraw = "withdraw"
        case newaddr = "newaddr"
        case dev_listaddrs = "dev-listaddrs"
        case listfunds = "listfunds"
        case dev_rescan_outputs = "dev-rescan-outputs"
    }
}
