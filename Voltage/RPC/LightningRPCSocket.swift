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
    case unwrap_error
}

protocol RPCProtocol {
    func send(query: LightningRPCQuery) -> Data
}

class LightningRPCSocket: NSObject, RPCProtocol {
    var socket: Socket?
    
    var buffer_size: Int = 4096
    
    var wait_timeout: UInt = 5000
    
    init?(path: String) {
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.unix
        let socket_path = NSString(string: path).expandingTildeInPath
        
        do {
            try socket = Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            guard let socket = socket else {
                print("unable to unwrap socket")
                throw SocketError.unwrap_error
            }
            socket.readBufferSize = buffer_size
            try socket.connect(to: socket_path)
        } catch {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RPC Error"), object: error)
            print("socket connection error: \(error)", socket_path)
            return nil
        }
    }
    
    // This is just `init` using the preferences value for the path
    class func create() -> LightningRPCSocket? {
        let prefs = Preferences()
        let socket_path = prefs.socket_path
        
        return  LightningRPCSocket(path: socket_path)
    }
    
    func send(query: LightningRPCQuery) -> Data {
        var read_data = Data(capacity: buffer_size)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(query)
            guard let socket = socket else {
                print("Unable to unwrap socket")
                throw SocketError.unwrap_error
            }
            try socket.write(from: data)
            
            // I'm pretty sure I should be using Socket.wait() here, but I was
            // having trouble getting it to work. This is fine for now, but it
            // should be sent to a background thread and have a timeout.
            // See https://github.com/IBM-Swift/BlueSocket#miscellaneous-utility-functions
            while true {
                let readable = try socket.isReadableOrWritable().readable
                if readable {
                    _ = try socket.read(into: &read_data)
                    // RPC calls with large payloads can take longer than one
                    // second to return. This all needs to be moved to another
                    // thread anyway. Good enough for the demo lol!!1!
                    sleep(1)
                    let still_readable = try socket.isReadableOrWritable().readable
                    if !still_readable {
                        break
                    }
                }
                sleep(1)
            }
            
            return read_data
        } catch {
            // Send the error to the notification center. This should be caught
            // by an observer that will trigger an alert in the main thread.
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RPC Error"), object: error)
            print("error communicating with RPC server", error)
            
            // Probably not the best way to handle this but for now...
            let response = "{\"message\":\"error\"}".data(using: .utf8)!
            return response
        }
    }
}
