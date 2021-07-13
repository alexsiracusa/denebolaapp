//
//  Week.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation
import SwiftDate

struct Week: Codable {
    let id: Int
    let ignoredDays: [Int]
    let startsOn: Date
    let week: WeekData

    var includedDays: [Day] {
        let week = week.days.enumerated().map { ignoredDays.contains($0) ? $1?.empty : $1 }
        return week.compactMap { $0 }
    }

    var startDateString: String {
        return startsOn.toFormat("M/d/yyyy")
    }

    func startAndEndTimes() -> (start: Date, end: Date) {
        let blocks = includedDays.flatMap { $0.blocks + $0.lunch }
        let startTime = blocks.map { $0.times.from }.min()
        let endTime = blocks.map { $0.times.to }.max()
        return (startTime!, endTime!)
    }

    static var `default`: Week {
        return Week(id: 0, ignoredDays: [5, 6], startsOn: Date(), week: WeekData.default)
    }
}

struct WeekData: Codable {
    let id: Int
    let name: String
    let days: [Day?]

    static var `default`: WeekData {
        return WeekData(id: 0, name: "Week 1", days: [Day.default, Day.default, Day.default, Day.default, Day.default, Day.default, Day.default])
    }
}
