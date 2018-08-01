//
//  SSHTunnel.swift
//  Voltage
//
//  Created by Ben Harold on 7/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

class SSHTunnel: SSHTunnelProtocol {
    let host: Host
    let port: Int
    let username: String
    let remote_socket_path: String
    let local_socket_path: String
    let task: Process = Process()
    
    init(host: Host, port: Int, username: String, remote_socket_path: String, local_socket_path: String) {
        self.host = host
        self.port = port
        self.username = username
        self.remote_socket_path = remote_socket_path
        self.local_socket_path = local_socket_path
    }
    
    func connect() -> URL {
        remove_existing_socket_file()
        let pipe = Pipe()
        task.launchPath = "/usr/bin/env"
        task.arguments = get_arguments()
        print("Attempting to create SSH tunnel with arguments:", task.arguments)
        task.standardError = pipe
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        task.launch()
        let url = URL(fileURLWithPath: local_socket_path)
        
        return url
    }
    
    private func get_arguments() -> [String] {
        let path_argument = local_socket_path + ":" + remote_socket_path
        let port_string = String(port)
        let host_string: String = host.address!
        let user_at_host = username + "@" + host_string
        
        return ["ssh", "-p", port_string, "-NL", path_argument, user_at_host, "&"]
    }
    
    // FIXME: This doesn't halt the existing ssh process.
    // Just run `ps aux|ag ssh` after connecting a few times
    // to see what I'm talking about.
    func remove_existing_socket_file() {
        if FileManager.default.fileExists(atPath: local_socket_path) {
            print("Removing existing socket:", local_socket_path)
            do {
                try FileManager.default.removeItem(atPath: local_socket_path)
            } catch {
                print("Error removing existing socket file: \(error)")
            }
        }
    }
}
