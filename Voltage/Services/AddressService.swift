//
//  AddressService.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa

class AddressService: NSObject {
    
    class func generate() -> String? {
        let decoder: JSONDecoder = JSONDecoder.init()
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let newaddr: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "newaddr", params: [])
        let response: Data = service.send(query: newaddr)
        
        do {
            let result: Address = try decoder.decode(AddressResult.self, from: response).result
            return result.address
        } catch {
            do {
                let error_message = try decoder.decode(ErrorResult.self, from: response).error
                NotificationCenter.default.post(name: Notification.Name(rawValue: "rpc_error"), object: error)
                print("RPC error: " + error_message)
            } catch {
                print("RPC error: \(error)")
            }
            print("AddressService JSON decoder error: \(error)")
        }
        
        return nil
    }
}
