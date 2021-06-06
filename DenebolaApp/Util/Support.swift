//
//  Support.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/12/21.
//

import Foundation

let DATE_FORMAT = "MMMM d, YYYY"

func getFormattedMinutesSeconds(_ seconds: Double) -> String {
    return String(format: "%02d:%02d", Int(seconds) / 60, Int(seconds) % 60)
}

func hourToAmPm(_ hour: Int) -> String {
    if hour > 12 {
        return "\(hour - 12) PM"
    } else {
        return "\(hour) AM"
    }
}
