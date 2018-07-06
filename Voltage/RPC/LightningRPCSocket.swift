//
//  LightningRPCSocket.swift
//  Voltage
//
//  Created by Ben Harold on 1/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa
import Socket

enum SocketError: Error {
    case unwrap
    case no_response
}

protocol RPCProtocol {
    func send(query: LightningRPCQuery) -> Data
}

class LightningRPCSocket: NSObject, RPCProtocol {
    
    let encoder: JSONEncoder = JSONEncoder.init()
    
    var socket: Socket?
    
    let buffer_size: Int = 4096
    
    let timeout: UInt = 5
    
    init?(path: String) {
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.unix
        let socket_path = NSString(string: path).expandingTildeInPath
        
        do {
            try socket = Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            guard let socket = socket else {
                throw SocketError.unwrap
            }
            socket.readBufferSize = buffer_size
            try socket.connect(to: socket_path)
        } catch {
            let path: [String: String] = ["socket_path": socket_path]
            NotificationCenter.default.post(name: Notification.Name.rpc_error,
                                            object: error, userInfo: path)
            print("socket connection error: \(error)", socket_path)
            return nil
        }
    }
    
    // This is just `init` using the preferences value for the path.
    // It mainly exists to make testing easier.
    class func create() -> LightningRPCSocket? {
        let prefs = Preferences()
        let socket_path = prefs.socket_path
        
        return  LightningRPCSocket(path: socket_path)
    }
    
    func send(query: LightningRPCQuery) -> Data {
        var response = Data(capacity: buffer_size)
        do {
            let request = try encoder.encode(query)
            guard let socket = socket else {
                throw SocketError.unwrap
            }
            try socket.write(from: request)
            _ = try Socket.wait(for: [socket], timeout: timeout)
            _ = try socket.read(into: &response)
            if response.isEmpty {
                throw SocketError.no_response
            }
            
            return response
        } catch {
            // Send the error to the notification center. This should be caught
            // by an observer that will trigger an alert in the main thread.
            NotificationCenter.default.post(name: Notification.Name.rpc_error, object: error)
            print("error communicating with RPC server", error)
            
            // Probably not the best way to handle this but for now...
            let response = "{\"message\":\"error\"}".data(using: .utf8)!
            return response
        }
    }
}
