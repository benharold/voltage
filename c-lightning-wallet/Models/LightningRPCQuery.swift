//
//  LightningRPCQuery.swift
//  c-lightning-wallet
//
//  Created by Ben Harold on 1/31/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct LightningRPCQuery: Encodable {
    let id: Int
    let method: String
    let params: [String]
}
