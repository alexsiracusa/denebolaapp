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
import SwiftDate
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

struct OpacityButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                VStack {
                    if configuration.isPressed {
                        BlurView()
                    }
                }
            )
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

// Additional formats to be parsed by the autoformatter in SwiftDate
// Used by MultiFormatter
func addAutoDateFormats() {
    DateFormats.autoFormats.append("yyyy-MM-dd'T'HH:mm:ss")
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

/**
 Retries a promise continously.
 - Parameter times: The number of times to retry
 - Parameter cooldown: Amount of time to wait before retrying.
 - Parameter shouldThrowError: A closure to determine whether we should stop retrying.
 - Parameter body: The promise to retry.

 - Returns: A promise.
 */
func retry<T>(times: Int, cooldown: TimeInterval, shouldThrowError: @escaping (Error) -> Bool = { _ in false }, body: @escaping () -> Promise<T>) -> Promise<T> {
    var retryCounter = 0
    func attempt() -> Promise<T> {
        return body().recover(policy: CatchPolicy.allErrorsExceptCancellation) { error -> Promise<T> in
            retryCounter += 1
            guard retryCounter <= times, !shouldThrowError(error) else {
                throw error
            }
            return after(seconds: cooldown).then(attempt)
        }
    }
    return attempt()
}
