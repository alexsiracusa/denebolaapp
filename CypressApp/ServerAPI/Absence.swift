//
//  Absence.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/19/21.
//

import Foundation

struct Absence: Codable, Identifiable {
    let id = UUID()

    let firstName: String
    let lastName: String
    let length: String
    let remarks: String

    var type: CancelledType {
        return length == "full" ? .full : .partial
    }

    static var `default`: Absence {
        return Absence(firstName: "Molly", lastName: "Estrada", length: "full", remarks: "all blocks cancelled")
    }
}

enum CancelledType {
    case full
    case partial
}
