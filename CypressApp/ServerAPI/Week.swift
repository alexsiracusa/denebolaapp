//
//  Week.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation

struct Week: Codable {
    let id: Int
    let ignoredDays: [String]
    let startsOn: String
    let week: WeekData
}

struct WeekData: Codable {
    let id: Int
    let name: String
    let days: [Day]
}

struct Day: Codable {
    let id: Int
    let name: String
    let blocks: [Block]
    let lunch: [Lunch]
}

struct Block: Codable {
    let id: Int
    let data: BlockData
    let times: Times
}

struct Times: Codable {
    let from: String
    let to: String
}

struct Lunch: Codable {
    let id: Int
    let name: String
    let times: Times
}
