//
//  PaymentListController.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class PaymentListController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
   
    var payment_list: [Payment] = [Payment.fake()]
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.payment_list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        return self.payment_list[row]
    }

}
