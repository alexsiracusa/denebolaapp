//
//  Block.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation

struct BlockData: Codable {
    let id: Int
    let name: String

    static var `default`: BlockData {
        return BlockData(id: Int.random(in: 0 ... 999), name: "Block")
    }
}
