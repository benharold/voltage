//
//  HandlesRPCErrors.swift
//  Voltage
//
//  Created by Ben Harold on 7/19/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

protocol HandlesRPCErrors {
    func is_rpc_error(response: Data) -> Bool
}

extension HandlesRPCErrors {
    func is_rpc_error(response: Data) -> Bool {
        do {
            let decoder = JSONDecoder()
            let rpc_error: RPCError = try decoder.decode(ErrorResult.self, from: response).error
            NotificationCenter.default.post(name: Notification.Name.rpc_error, object: rpc_error)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
