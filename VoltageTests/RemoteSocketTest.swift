//
//  RemoteSocketTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 7/20/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Socket

// Here I'm just playing around with sockets. None of this stuff is directly
// applicable to Voltage.
class RemoteSocketTest: XCTestCase {

    func testExecuteSSHFromSwift() {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["ssh", "-NL", "./lightning-rpc:/home/ben/.lightning/lightning-rpc", "ben@10.0.1.100"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        print(output)
    }
    
    func testLocalConnoction() {
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.tcp
        
        do {
            var response = Data(capacity: 4096)
            let socket: Socket = try Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            socket.readBufferSize = 4096
            sleep(2)
            _ = try socket.connect(to: "./lightning-rpc")
            print(socket.isActive)
            print(try socket.isReadableOrWritable())
            let message = "hello world".data(using: .utf8)!
            try socket.write(from: message)
        } catch {
            print(error)
        }
    }

    func testRemoteConnection() {
        let socket_family = Socket.ProtocolFamily.inet
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.tcp
        
        do {
            var response = Data(capacity: 4096)
            let socket = try Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            print(socket)
            socket.readBufferSize = 4096
            sleep(2)
            _ = try socket.connect(to: "10.0.1.100", port: 22)
            print("result", socket)
            print(socket.isActive)
            print(try socket.isReadableOrWritable())
            let message = "hello world".data(using: .utf8)
            try socket.write(from: message!)
            _ = try socket.read(into: &response)
            print(String(data: response, encoding: .utf8))
        } catch {
            print(error)
        }
        
    }

}
