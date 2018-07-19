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
        guard let socket = LightningRPCSocket.create() else { return nil }
        let query = LightningRPCQuery(LightningRPC.Method.newaddr)
        let response: Data = socket.send(query)
        do {
            let result: Address = try decoder.decode(AddressResult.self, from: response).result
            return result.address
        } catch {
            if is_rpc_error(response: response) { return nil }
            print(error)
        }
        
        return nil
    }
    
    private class func is_rpc_error(response: Data) -> Bool {
        do {
            let decoder = JSONDecoder.init()
            let rpc_error: RPCError = try decoder.decode(ErrorResult.self, from: response).error
            NotificationCenter.default.post(name: Notification.Name.rpc_error, object: rpc_error)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
