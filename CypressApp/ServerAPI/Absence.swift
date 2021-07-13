//
//  Absence.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation

struct Absences: Codable {
    let timestamp: String
    let absences: [Absence]

    var dateString: String {
        timestamp.toISODate(region: .UTC)?.convertTo(region: .local).toRelative() ?? timestamp
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
