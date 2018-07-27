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
            let path = UserDefaults.standard.string(forKey: PreferenceDefaults.socket_path_key) ?? PreferenceDefaults.socket_path

            return path
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceDefaults.socket_path_key)
        }
    }
}
