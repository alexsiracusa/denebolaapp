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
    let dayOfWeek: String
    let blocks: [Block]
    let lunch: [Lunch]

    var blocksAndLunches: [DisplayBlock] {
        let combined: [DisplayBlock] = blocks + lunch
        return combined.sorted(by: { $0.times < $1.times })
    }

    static var `default`: Day {
        let blocks = [Block(id: 0, data: BlockData(id: 0, name: "A"), times: Times(from: "9:15 AM", to: "10:35 AM")), Block(id: 1, data: BlockData(id: 1, name: "B"), times: Times(from: "10:45 AM", to: "12:55 PM")), Block(id: 2, data: BlockData(id: 1, name: "C"), times: Times(from: "1:05 PM", to: "2:25 PM")), Block(id: 3, data: BlockData(id: 1, name: "D"), times: Times(from: "2:35 PM", to: "3:55 PM"))]
        let lunches = [Lunch(id: 0, name: "1st Lunch", times: Times(from: "10:45 AM", to: "11:20 AM")), Lunch(id: 1, name: "2nd Lunch", times: Times(from: "11:30 AM", to: "12:05 PM")), Lunch(id: 2, name: "3rd Lunch", times: Times(from: "12:20 PM", to: "12:55 PM"))]
        return Day(id: 0, name: "Monday", dayOfWeek: "Monday", blocks: blocks, lunch: lunches)
    }

    var empty: Day {
        return Day(id: -1, name: "No School", dayOfWeek: dayOfWeek, blocks: [], lunch: [])
    }
}
