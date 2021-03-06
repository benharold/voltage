//
//  NotificationName.swift
//  Voltage
//
//  Created by Ben Harold on 7/3/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let debug_message = Notification.Name("debug_message")
    static let loading_finish = Notification.Name("loading_finish")
    static let loading_start = Notification.Name("loading_start")
    static let reload = Notification.Name("reload")
    static let rpc_error = Notification.Name("rpc_error")
    static let socket_error = Notification.Name("socket_error")
}
