//
//  Blocks.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import Foundation

protocol DisplayBlock {
    var displayId: UUID { get }
    var times: Times { get }
}

struct Block: Codable, Identifiable, DisplayBlock {
    var displayId: UUID { return UUID() }

    let id: Int
    let data: BlockData
    let times: Times

    static var `default`: Block {
        return Block(id: 0, data: BlockData(id: 0, name: "A"), times: Times(from: "9:15 AM", to: "10:35 AM"))
    }
}

struct Lunch: Codable, DisplayBlock {
    var displayId: UUID { return UUID() }

    let id: Int
    let name: String
    let times: Times

    var asBlock: Block {
        return Block(id: id, data: BlockData(id: id, name: name), times: times)
    }

    static var `default`: Lunch {
        return Lunch(id: 0, name: "1st Lunch", times: Times(from: "10:45 AM", to: "11:20 AM"))
    }
}

struct Times: Codable {
    let from: String
    let to: String

    var fromDate: Date {
        return Date(timeString: from)!
    }

    var toDate: Date {
        return Date(timeString: to)!
    }

    var length: TimeInterval {
        return toDate - fromDate
    }

    static func < (lhs: Times, rhs: Times) -> Bool {
        if lhs.from != rhs.from {
            return lhs.fromDate < rhs.fromDate
        } else {
            return lhs.length > rhs.length
        }
    }
}
