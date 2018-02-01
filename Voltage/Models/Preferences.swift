//
//  Preferences.swift
//  Voltage
//
//  Created by Ben Harold on 1/30/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Preferences {
    var socket_path: String {
        get {
            let path = UserDefaults.standard.string(forKey: "socket_path") ?? "~/lightning/lightning-rpc"

            return path
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "socket_path")
        }
    }
}
