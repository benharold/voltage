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
        } catch Swift.DecodingError.dataCorrupted(let decoding_error) {
            // Sometimes a response payload will get truncated before the entire
            // response is read from the socket. In that case, the decoder won't
            // be able to decode the JSON.
            let error_text = "The response JSON could not be decoded. Please try again."
            NotificationCenter.default.post(name: Notification.Name.rpc_error,
                                            object: error_text)
            print(decoding_error)
        } catch {
            // If it's a decodeable RPCError, this will handle notifications.
            if is_rpc_error(response: response) { return nil }
            
            // Otherwise dump the entire error object to the error handler.
            NotificationCenter.default.post(name: Notification.Name.rpc_error,
                                            object: error)
            print(error)
        }
        
        return nil
    }
}
