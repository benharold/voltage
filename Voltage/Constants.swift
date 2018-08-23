//
//  Constants.swift
//  Voltage
//
//  Created by Ben Harold on 7/16/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Constant {
    static let node_location_key = "node_location"
    static let setup_complete_key = "setup_complete"
    // MARK: Local
    static let socket_path_key = "socket_path"
    static let default_socket_path = "~/.lightning/lightning-rpc"
    // MARK: Remote
    static let remote_host_key = "remote_host"
    static let remote_port_key = "remote_port"
    static let remote_username_key = "remote_username"
    static let remote_socket_path_key = "remote_socket_path"
}

enum NodeLocation: String {
    case local
    case remote
}
