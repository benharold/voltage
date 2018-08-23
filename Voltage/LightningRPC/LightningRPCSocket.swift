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
    func send(_ query: LightningRPCQuery) -> Data
}

class LightningRPCSocket: NSObject, RPCProtocol {
    
    let encoder: JSONEncoder = JSONEncoder.init()
    
    var socket: Socket?
    
    let buffer_size: Int = Socket.SOCKET_DEFAULT_READ_BUFFER_SIZE // 4096
    
    init?(path: String) {
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.unix
        let socket_path = NSString(string: path).expandingTildeInPath
        
        do {
            try socket = Socket.create(family: socket_family,
                                       type: socket_type,
                                       proto: socket_protocol)
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
    
    // Create a new instance according to the user's preferences.
    class func create() -> LightningRPCSocket? {
        let prefs = Preferences()
        var socket_path: String = ""
        if prefs.node_location == NodeLocation.local {
            let local_prefs = Preferences.Local()
            socket_path = local_prefs.socket_path
        } else {
            socket_path = ApplicationSupportFolder().path + "/lightning-rpc"
        }

        return LightningRPCSocket(path: socket_path)
    }
    
    func send(_ query: LightningRPCQuery) -> Data {
        print(query)
        var response = Data(capacity: buffer_size)
        do {
            let request = try encoder.encode(query)
            guard let socket = socket else {
                throw SocketError.unwrap
            }
            try socket.write(from: request)
            var bytes_read: Int = try socket.read(into: &response)
            
            // Payloads larger than 36544 bytes may or may not be split up into
            // chunks of 36544 bytes. In that case, we need to wait for more
            // data to be available on the socket, then read again.
            //
            // If the next chunk of data is 36544 bytes, we continue to wait for
            // more data, otherwise we assume the payload is complete.
            while bytes_read == 36544 {
                _ = try Socket.wait(for: [socket], timeout: 10)
                bytes_read = try socket.read(into: &response)
            }
            
            if response.isEmpty {
                throw SocketError.no_response
            }
            
            return response
        } catch {
            NotificationCenter.default.post(name: Notification.Name.rpc_error,
                                            object: error)
            print("error communicating with RPC server", error)
            
            // Probably not the best way to handle this but for now...
            let response = "{\"message\":\"error\"}".data(using: .utf8)!
            return response
        }
    }
}
