//
//  SchoolYear.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/6/21.
//

import Foundation

struct SchoolYear: Codable, Equatable {
    let id: Int
    let name: String
    let start_date: Date
    let end_date: Date

    var currentWeek: Date {
        return weeks.first(where: { $0.isInCurrentWeek() }) ?? end_date
    }

    var currentWeekIndex: Int {
        return weeks.firstIndex(where: { $0.isInCurrentWeek() }) ?? weeks.count - 1
    }

    enum CodingKeys: CodingKey {
        case id, name, start_date, end_date
    }

    var weeks: [Date] {
        var weeks = [Date]()
        var currentWeek = start_date.dayInWeek(.monday).dateAtStartOf(.day)
        let end = end_date.dayInWeek(.sunday).dateAtStartOf(.day)
        while currentWeek <= end {
            weeks.append(currentWeek)
            currentWeek = currentWeek.dateByAdding(7, .day).date
        }
        return weeks
    }
}
