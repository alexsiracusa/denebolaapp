//
//  Support.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/12/21.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftUI

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

func sealResult<D, E>(_ seal: Resolver<D>, _ result: Result<D, E>) {
    switch result {
    case let .success(data):
        seal.fulfill(data)
    case let .failure(error):
        seal.reject(error)
    }
}

struct NoButtonAnimation: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
