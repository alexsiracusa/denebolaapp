//
//  DateTests.swift
//  CypressTests
//
//  Created by Connor Tam on 7/20/21.
//

@testable import Denebola
import SwiftDate
import XCTest

class DateTests: XCTestCase {
    // Week should start on Monday
    func testDayInWeek() {
        let sunday = Date(year: 2021, month: 07, day: 18, hour: 0, minute: 0)
        let monday = Date(year: 2021, month: 07, day: 19, hour: 0, minute: 0)
        // Sunday should be in the same week as itself
        XCTAssertEqual(sunday.dayInWeek(.sunday), sunday)
        // The week the current sunday is in should have last monday
        let lastMonday = monday
            .dateByAdding(-1, .weekOfMonth)
            .date

        XCTAssertEqual(sunday.dayInWeek(.monday), lastMonday)
        // Monday should be in the same week as itself
        XCTAssertEqual(monday.dayInWeek(.monday), monday.date)
    }

    func testIsInCurrentWeek() throws {
        // Start of week on monday (monday at 12:00am)
        XCTAssert(
            Date()
                .dayInWeek(.monday)
                .isInCurrentWeek()
        )
        // End of week (sunday at 11:59pm)
        XCTAssert(
            Date()
                .dayInWeek(.sunday)
                .dateByAdding(86399, .second)
                .date
                .isInCurrentWeek(from: .local)
        )

        // Beginning of next week (monday at 12:00am)
        XCTAssertFalse(
            Date()
                .nextWeekday(.monday)
                .isInCurrentWeek()
        )

        // Right at the end of the previous week (sunday at 11:59pm)
        XCTAssertFalse(
            Date()
                .dayInWeek(.monday)
                .dateByAdding(-1, .second)
                .date
                .isInCurrentWeek()
        )

        // In the middle of the week
        XCTAssert(
            Date()
                .dayInWeek(.wednesday)
                .isInCurrentWeek()
        )
    }
}
