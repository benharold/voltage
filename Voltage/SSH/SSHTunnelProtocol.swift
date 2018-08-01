//
//  SSHSessionProtocol.swift
//  Voltage
//
//  Created by Ben Harold on 7/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

protocol SSHTunnelProtocol {
    // Use an SSH tunnel to connect a local socket to a remote socket.
    // Return the URL of the local socket.
    func connect() -> URL
}
