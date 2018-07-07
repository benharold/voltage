//
//  GetMoneyView.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class GetMoneyViewController: NSViewController {
    
    var funding_address: String = ""
    
    @IBOutlet weak var funding_address_text_field: NSTextField!
    
    @IBOutlet weak var funding_address_qr_code_field: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_new_address()
        get_qr_code()
    }
    
    func get_new_address() {
        funding_address = AddressService.generate() ?? "error"
        funding_address_text_field.stringValue = funding_address
    }
    
    func get_qr_code() {
        let qrcode = QRcode_encodeString8bit(funding_address, 3, QR_ECLEVEL_L)
        let image_data = qrcode?.pointee.data!

        // Uh...this started out as me just trying to figure out if I was
        // accessing valid QR code data, but then it just kind of turned into
        // an emoji-based bitmap generator. ¯\_(ツ)_/¯
        var bitmap = "\n\n"
        for height_index in 0...28 {
            for width_index in 0...28 {
                var terminator = ""
                if width_index == 28 {
                    terminator = "\n"
                }
                if image_data![height_index * 29 + width_index] % 2 == 1 {
//                    print("⬜", terminator: terminator)
                    bitmap += "⬜"
                } else {
//                    print("⬛", terminator: terminator)
                    bitmap += "⬛"
                }
                bitmap += terminator
            }
        }

        funding_address_qr_code_field.stringValue = bitmap
    }
    
}
