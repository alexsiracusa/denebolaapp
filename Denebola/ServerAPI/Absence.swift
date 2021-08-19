//
//  Absence.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation
import SwiftDate

struct Absences: Codable {
    let postedAt: Date
    let updatedAt: Date
    let absences: [Absence]

    var dateString: String {
        DateInRegion(updatedAt, region: .local).toRelative()
    }
}

struct Absence: Codable, Identifiable {
    let id = UUID()

    let firstName: String
    let lastName: String
    let remarks: String

    func hasRemarks() -> Bool {
        return remarks != ""
    }

    static var `default`: Absence {
        return Absence(firstName: "Molly", lastName: "Estrada", remarks: "all blocks cancelled")
    }
}

enum CancelledType {
    case full
    case partial
}
