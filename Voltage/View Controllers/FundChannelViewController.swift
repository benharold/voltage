//
//  FundChannelViewController.swift
//  Voltage
//
//  Created by Ben Harold on 7/19/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class FundChannelViewController: NSViewController {

    var peer: Peer?
    
    @IBAction func cancel_button(_ sender: Any) {
        self.dismiss(self)
    }
    
    func set_data(_ peer: Peer) {
        print(peer)
        self.peer = peer
    }

}
