//
//  Day.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import Foundation

struct Day: Codable, Identifiable {
    let id: Int
    let name: String
    let dayOfWeek: DayOfWeek
    let blocks: [Block]
    let lunch: [Block]

    var blocksAndLunches: [Block] {
        let combined: [Block] = blocks + lunch
        return combined.sorted(by: { $0.times < $1.times })
    }

    static var `default`: Day {
        let blocks = [Block(id: 0, data: BlockData(id: 0, name: "A", blockType: .course), times: Times(from: "9:15 AM", to: "10:35 AM")), Block(id: 1, data: BlockData(id: 1, name: "B", blockType: .course), times: Times(from: "10:45 AM", to: "12:55 PM")), Block(id: 2, data: BlockData(id: 1, name: "C", blockType: .course), times: Times(from: "1:05 PM", to: "2:25 PM")), Block(id: 3, data: BlockData(id: 1, name: "D", blockType: .course), times: Times(from: "2:35 PM", to: "3:55 PM"))]
        let lunches = [Block(id: 0, data: BlockData(id: 0, name: "1st Lunch", blockType: .lunch), times: Times(from: "10:45 AM", to: "11:20 AM")), Block(id: 0, data: BlockData(id: 1, name: "2nd Lunch", blockType: .lunch), times: Times(from: "11:30 AM", to: "12:05 PM")), Block(id: 0, data: BlockData(id: 2, name: "3rd Lunch", blockType: .lunch), times: Times(from: "12:20 PM", to: "12:55 PM"))]
        return Day(id: 0, name: "Monday", dayOfWeek: .monday, blocks: blocks, lunch: lunches)
    }

    var empty: Day {
        return Day(id: -1, name: "No School", dayOfWeek: dayOfWeek, blocks: [], lunch: [])
    }
}
