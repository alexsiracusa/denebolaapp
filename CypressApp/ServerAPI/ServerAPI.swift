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

var policy = RetryPolicy(retryLimit: 5, exponentialBackoffBase: 3, exponentialBackoffScale: 0)

let SERVER_URL = "https://www.denebolaapp.com/api"

enum ServerAPI {
    static func getSchools() -> Promise<[School]> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools", method: .get, interceptor: Retry()).responseDecodable(of: [School].self) { response in
                sealResult(seal, response.result)
            }
        }
    }
}

struct School: Codable, Identifiable, Hashable {
    let id: Int
    let name: String

    func getConfig(delay: Double = 2.5, retryCount: UInt = UInt.max, timeOut: Double = 60) -> Promise<SchoolConfig> {
        let retry = Retry(delay: delay, maxRetryCount: retryCount)
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/config", method: .get, interceptor: retry)
                { $0.timeoutInterval = TimeInterval(timeOut) }
                .validate().responseDecodable(of: SchoolConfig.self) { response in
                    sealResult(seal, response.result)
                }
        }
    }

    func getAbsences(date: Date) -> Promise<Absences> {
        let dateString = DateInRegion(date, region: .local).toFormat("yyyy-MM-dd")
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/absences/\(dateString)", method: .get, interceptor: Retry())
                .validate().responseDecodable(of: Absences.self, decoder: MultiFormatter()) { response in
                    sealResult(seal, response.result)
                }
        }
    }

    func getLatestAbsences() -> Promise<Absences> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/absences/latest", method: .get, interceptor: Retry()).validate().responseDecodable(of: Absences.self, decoder: MultiFormatter()) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getCourses(delay: Double = 2.5, retryCount: UInt = UInt.max, timeOut: Double = 60) -> Promise<[BlockData]> {
        let retry = Retry(delay: delay, maxRetryCount: retryCount)
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/blocks/courses", method: .get, interceptor: retry)
                { $0.timeoutInterval = TimeInterval(timeOut) }
                .validate().responseDecodable(of: [BlockData].self) { response in
                    sealResult(seal, response.result)
                }
        }
    }

    func getWeek(date: Date) -> Promise<Week> {
        let dateString = DateInRegion(date).toFormat("yyyy-MM-dd")
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/weeks/\(dateString)", method: .get, interceptor: Retry()).validate().responseDecodable(of: Week.self, decoder: MultiFormatter()) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getDay(date: Date) -> Promise<Day> {
        getDay(date: DateInRegion(date))
    }

    func getDay(date: DateInRegion) -> Promise<Day> {
        let dateString = date.toFormat("yyyy-MM-dd")
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/days/\(dateString)", method: .get, interceptor: Retry()).validate().responseDecodable(of: Day.self, decoder: MultiFormatter()) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getLatestYear() -> Promise<SchoolYear> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/years/latest", method: .get, interceptor: Retry()).validate().responseDecodable(of: SchoolYear.self, decoder: MultiFormatter()) { response in
                sealResult(seal, response.result)
            }
        }
    }

    static var `default`: School {
        return School(id: 0, name: "Newton South High School")
    }
}
