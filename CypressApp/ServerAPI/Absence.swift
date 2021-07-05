//
//  Absence.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation

struct Absences: Codable {
    let date: String
    let absences: [Absence]

    var dateString: String {
        let date = Date(date, format: "yyyy-MM-dd", region: .local)
        guard let date = date else { return "Unknown" }
        return date.toFormat("M/d/yyyy")
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
