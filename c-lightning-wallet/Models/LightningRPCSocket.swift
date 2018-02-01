//
//  LightningRPCSocket.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa
import Socket

enum SocketError: Error {
    case unwrap_error
}

protocol RPCProtocol {
    func send(query: LightningRPCQuery) -> String
}

class LightningRPCSocket: NSObject, RPCProtocol {
    var socket: Socket?
    
    var buffer_size: Int = 4096
    
    var wait_timeout: UInt = 5000
    
    init(path: String) {
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.unix
        
        do {
            try socket = Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            guard let socket = socket else {
                print("unable to unwrap socket")
                throw SocketError.unwrap_error
            }
            socket.readBufferSize = buffer_size
            try socket.connect(to: path)
        } catch {
            // This really should broadcast a message so that a logger can
            // pick it up and/or the user can be notified in some manner.
            print("socket connection error: \(error)")
        }
    }
    
    func send(query: LightningRPCQuery) -> String {
        var response = "{ \"message\": \"no response from RPC server\" }"
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(query)
            guard let socket = socket else {
                print("Unable to unwrap socket")
                throw SocketError.unwrap_error
            }
            try socket.write(from: data)
            
            // I'm pretty sure I should be using Socket.wait() here, but I was
            // having trouble getting it to work. This is fine for now, but
            // should be sent to a background thread.
            // See https://github.com/IBM-Swift/BlueSocket#miscellaneous-utility-functions
            while true {
                let readable = try socket.isReadableOrWritable().readable
                if readable {
                    var read_data = Data(capacity: buffer_size)
                    try socket.read(into: &read_data)
                    response = String(data: read_data, encoding: .utf8) as String!
                    break
                }
                sleep(1)
            }
            
            return response
        } catch {
            print("error communicating with RPC server", error)
            return "{ \"message\": \"error communicating with RPC server\" }"
        }
    }
}
