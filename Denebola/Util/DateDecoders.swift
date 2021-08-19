//
//  DateDecoders.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/12/21.
//

import Foundation
import SwiftDate

class MultiFormatter: JSONDecoder {
    // Modify addAutoFormats() in Support.swift to add more date formats

    override init() {
        super.init()

        dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            // Checks every format in DateFormats.autoFormats
            let date = Date(dateStr)

            guard let date = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }

            return date
        }
    }
}
