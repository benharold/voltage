//
//  SSHSessionTest.swift
//  VoltageTests
//
//  Created by Ben Harold on 7/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import XCTest
@testable import Voltage

class SSHTunnelTest: XCTestCase {
    
    let host = ""
    let port = 22
    let username = ""
    let remote_path = ""

    func testCreateTunnel() {
        let path = ApplicationSupportFolder().path + "/lightning-rpc"
        let host = Host(address: self.host)
        let tunnel = SSHTunnel(host: host,
                               port: port,
                               username: username,
                               remote_socket_path: remote_path,
                               local_socket_path: path)
        tunnel.connect()
        Swift.print(tunnel, tunnel.local_socket_path)
        let rpc = LightningRPCSocket(path: tunnel.local_socket_path)
        Swift.print(rpc?.socket?.isConnected)
    }
}
