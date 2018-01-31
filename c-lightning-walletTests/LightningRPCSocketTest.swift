//
//  LightningRPCSocketTest.swift
//  c-lightning-walletTests
//
//  Created by Ben Harold on 1/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
import Socket
@testable import c_lightning_wallet

class LightningRPCSocketTest: XCTestCase {
    
    // This MUST be a path to an active c-lightning node socket
    // in order for these tests to pass.
    var relative_path = "~/Development/sockets/lightning-rpc.sock"
    
    // The socket path must be an absolute path. Here I was just figuring out
    // the best way to support the `~` character in the preferences pane.
    func testPaths() {
        let path_with_tilde = "~/lightning/lightning-rpc"
        let full_path = FileManager.default.homeDirectoryForCurrentUser.path + "/lightning/lightning-rpc"
        XCTAssertEqual(NSString(string: path_with_tilde).expandingTildeInPath, full_path)
        
        let path_without_tilde = "/dev/null"
        XCTAssertEqual(NSString(string: path_without_tilde).expandingTildeInPath, path_without_tilde)
    }
    
    func testConnectToRPCServer() {
        let path = NSString(string: relative_path).expandingTildeInPath
        let socket_family = Socket.ProtocolFamily.unix
        let socket_type = Socket.SocketType.stream
        let socket_protocol = Socket.SocketProtocol.unix
        var socket: Socket?
        
        do {
            try socket = Socket.create(family: socket_family, type: socket_type, proto: socket_protocol)
            guard let socket = socket else {
                print("Unable to unwrap socket")
                throw SocketError.unwrap_error
            }
            socket.readBufferSize = 4096
            try socket.connect(to: path)
        } catch {
            print("socket connection error: \(error)")
        }
        XCTAssert(socket!.isConnected)
    }
    
    func testSendQuery() {
        let path = NSString(string: relative_path).expandingTildeInPath
        let socket = LightningRPCSocket(path: path)
        let query = LightningRPCQuery(
            id: 1,
            method: "getinfo",
            params: []
        )
        print(socket.send(query: query))
    }

}
