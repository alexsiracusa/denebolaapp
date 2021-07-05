//
//  Blocks.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import Foundation

struct Block: Codable, Identifiable {
    var displayId: UUID { return UUID() }

    let id: Int
    let data: BlockData
    let times: Times

    static var `default`: Block {
        return Block(id: 0, data: BlockData(id: 0, name: "A", blockType: .course), times: Times(from: "9:15 AM", to: "10:35 AM"))
    }
}

struct Times: Codable {
    let from: Date
    let to: Date

    enum CodingKeys: CodingKey {
        case from, to
    }

    init(from: String, to: String) {
        self.from = Date(from, format: "HH:mm:ss", region: .local)!
        self.to = Date(to, format: "HH:mm:ss", region: .local)!
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // region needs to be .UTC to avoid offsetting the times
        from = Date(try container.decode(String.self, forKey: .from), format: "HH:mm:ss", region: .UTC)!
        to = Date(try container.decode(String.self, forKey: .to), format: "HH:mm:ss", region: .UTC)!
    }

    var length: TimeInterval {
        return to - from
    }

    func fromString() -> String {
        from.toFormat(TIME_FORMAT)
    }

    func toString() -> String {
        to.toFormat(TIME_FORMAT)
    }

    static func < (lhs: Times, rhs: Times) -> Bool {
        if lhs.from != rhs.from {
            return lhs.from < rhs.from
        } else {
            return lhs.length > rhs.length
        }
    }
}
