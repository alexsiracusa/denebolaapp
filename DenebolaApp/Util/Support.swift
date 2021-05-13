//
//  Support.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/12/21.
//

import Foundation

func getFormattedMinutesSeconds(_ seconds: Double) -> String {
    return String(format: "%02d:%02d", Int(seconds) / 60, Int(seconds) % 60)
}
