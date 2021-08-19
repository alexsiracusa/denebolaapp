//
//  ServerAPIHandler.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftDate

let SERVER_URL = "https://www.denebolaapp.com/api"

let session: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5
    return Session(configuration: configuration)
}()

enum ServerAPI {
    static func getSchools() -> CachingRequest<[School]> {
        let request = session.request("\(SERVER_URL)/schools", method: .get)

        return CachingRequest(with: request)
    }
}

struct School: Codable, Identifiable, Hashable {
    let id: Int
    let name: String

    func getConfig() -> CachingRequest<SchoolConfig> {
        let request = session.request("\(SERVER_URL)/schools/\(id)/config", method: .get)

        return CachingRequest(with: request)
    }

    func getAbsences(date: Date) -> CachingRequest<Absences> {
        let dateString = DateInRegion(date, region: .local).toFormat("yyyy-MM-dd")
        let request = session.request("\(SERVER_URL)/schools/\(id)/absences/\(dateString)", method: .get, interceptor: Retry())

        return CachingRequest(with: request)
    }

    func getLatestAbsences() -> CachingRequest<Absences> {
        let request = session.request("\(SERVER_URL)/schools/\(id)/absences/latest", method: .get)
        return CachingRequest(with: request)
    }

    func getCourses() -> CachingRequest<[BlockData]> {
        let request = session.request("\(SERVER_URL)/schools/\(id)/schedule/blocks/courses", method: .get)
        return CachingRequest(with: request)
    }

    func getWeek(date: Date) -> CachingRequest<Week> {
        let dateString = DateInRegion(date).toFormat("yyyy-MM-dd")
        let request = session.request("\(SERVER_URL)/schools/\(id)/schedule/weeks/\(dateString)", method: .get)
        return CachingRequest(with: request)
    }

    func getLatestYear() -> CachingRequest<SchoolYear> {
        let request = session.request("\(SERVER_URL)/schools/\(id)/schedule/years/latest", method: .get)
        return CachingRequest(with: request)
    }

    func getDay(date: Date) -> CachingRequest<Day> {
        getDay(date: DateInRegion(date))
    }

    func getDay(date: DateInRegion) -> CachingRequest<Day> {
        let dateString = date.toFormat("yyyy-MM-dd")
        let request = session.request("\(SERVER_URL)/schools/\(id)/schedule/days/\(dateString)", method: .get)
        return CachingRequest(with: request)
    }

    static var `default`: School {
        return School(id: 0, name: "Newton South High School")
    }
}
