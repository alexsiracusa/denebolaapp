//
//  DateDecoders.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/12/21.
//

import Foundation

class MultiFormatter: JSONDecoder {
    static var dateNoTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static var timeDateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    static var iso8601DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    // can easily add more formats and put in init if needed

    override init() {
        super.init()
        dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            var date: Date?

            date = (
                MultiFormatter.dateNoTimeFormatter.date(from: dateStr) ??
                    MultiFormatter.timeDateFormatter.date(from: dateStr) ??
                    MultiFormatter.iso8601DateFormatter.date(from: dateStr)
            )

            guard let date = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date
        }
    }
}
