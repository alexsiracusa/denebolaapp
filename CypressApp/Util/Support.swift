//
//  Support.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/12/21.
//

import Alamofire
import Foundation
import Nuke
import PromiseKit
import SwiftUI

let DATE_FORMAT = "MMMM d, YYYY"
let TIME_FORMAT = "h:mm a"
let SERVER_TIME_FORMAT = "hh:mm:ss"
let TIME_SCALE: Int32 = 600

func getFormattedMinutesSeconds(_ seconds: Double) -> String {
    // had this crash once at ", Int(seconds / 60" saying it couldn't convert Double to Int because it's either NaN or infinite.  Can't reproduce so idk what to fix.  Crashed when I clicked on a new episode.
    guard !seconds.isInfinite, !seconds.isNaN else { return "00:00" }
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
            .contentShape(Rectangle())
    }
}

enum DayOfWeek: String, CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    func toIndex() -> Int {
        return DayOfWeek.allCases.firstIndex(of: self)!
    }
}

func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .rigid) {
    let impactMed = UIImpactFeedbackGenerator(style: style)
    impactMed.impactOccurred()
}

extension FetchImage {
    static func load(_ url: URL?) -> Promise<ImageResponse> {
        return Promise { seal in
            let image = FetchImage()
            image.onCompletion = { result in
                sealResult(seal, result)
            }
            image.load(url)
        }
    }
}
