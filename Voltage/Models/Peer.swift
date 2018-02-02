//
//  Peer.swift
//  Voltage
//
//  Created by Ben Harold on 1/26/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Foundation

struct Peer: Codable {
    let id: String
    let connected: Bool
    let netaddr: [String]?
    let channels: [Channel]
    
    enum PeerKeys: String, CodingKey {
        case peers
    }
}

struct PeerList: Codable {
    let peers: [Peer]
}
