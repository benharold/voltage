//
//  Preferences.swift
//  Voltage
//
//  Created by Ben Harold on 1/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Preferences {
    var node_location: NodeLocation {
        get {
            let raw_value: String = UserDefaults.standard.string(forKey: Constant.node_location_key) ?? NodeLocation.local.rawValue
            
            return NodeLocation(rawValue: raw_value)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constant.node_location_key)
        }
    }
    
    var setup_complete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constant.setup_complete_key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.setup_complete_key)
        }
    }
    
    struct Local {
        var socket_path: String {
            get {
                let path = UserDefaults.standard.string(forKey: Constant.socket_path_key) ?? Constant.default_socket_path

                return path
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constant.socket_path_key)
            }
        }
    }
    
    struct Remote {
        var host: String {
            get {
                let host: String = UserDefaults.standard.string(forKey: Constant.remote_host_key) ?? ""
                
                return host
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constant.remote_host_key)
            }
        }
        var port: Int {
            get {
                var port: Int = UserDefaults.standard.integer(forKey: Constant.remote_port_key)
                port = (port == 0) ? 22 : port
                
                return port
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constant.remote_port_key)
            }
        }
        var username: String {
            get {
                let username: String = UserDefaults.standard.string(forKey: Constant.remote_username_key) ?? ""
                
                return username
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constant.remote_username_key)
            }
        }
        var remote_socket_path: String {
            get {
                let path: String = UserDefaults.standard.string(forKey: Constant.remote_socket_path_key) ?? ""
                
                return path
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Constant.remote_socket_path_key)
            }
        }
    }
}
