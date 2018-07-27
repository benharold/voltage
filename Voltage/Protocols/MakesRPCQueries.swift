//
//  MakesRPCQueries.swift
//  Voltage
//
//  Created by Ben Harold on 7/27/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

protocol MakesRPCQueries {
    func query<T: Decodable>(_ method: LightningRPC.Method) -> T?
}

extension MakesRPCQueries where Self: HandlesRPCErrors {
    func query<T: Decodable>(_ method: LightningRPC.Method) -> T? {
        guard let socket = LightningRPCSocket.create() else { return nil }
        let query = LightningRPCQuery(method)
        let response: Data = socket.send(query)
        let decoder = JSONDecoder()
        do {
            let result: T = try decoder.decode(T.self, from: response)
            return result
        } catch {
            if is_rpc_error(response: response) { return nil }
            print(error)
        }
        
        return nil
    }
}
