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

let SERVER_URL = "https://cypress.sequal.xyz"

enum ServerAPI {
    static func getSchools() -> Promise<[School]> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools", method: .get, interceptor: Retry()).responseDecodable(of: [School].self) { response in
                sealResult(seal, response.result)
            }
        }
    }
}

struct School: Codable, Identifiable {
    let id: Int
    let name: String

    func getConfig() -> Promise<SchoolConfig> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/config", method: .get, interceptor: Retry()).validate().responseDecodable(of: SchoolConfig.self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getAbsences(date: Date) -> Promise<Absences> {
        let dateString = DateInRegion(date, region: .local).toFormat("yyyy-MM-dd")
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/absences/\(dateString)", method: .get, interceptor: Retry()).validate().responseDecodable(of: Absences.self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getLatestAbsences() -> Promise<Absences> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/absences/latest", method: .get, interceptor: Retry()).validate().responseDecodable(of: Absences.self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getCourses() -> Promise<[BlockData]> {
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/blocks/courses", method: .get, interceptor: Retry()).validate().responseDecodable(of: [BlockData].self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getWeek(date: Date) -> Promise<Week> {
        let dateString = DateInRegion(date, region: .local).toFormat("yyyy-MM-dd")
        return Promise { seal in
            AF.request("\(SERVER_URL)/schools/\(id)/schedule/weeks/\(dateString)", method: .get, interceptor: Retry()).validate().responseDecodable(of: Week.self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    static var `default`: School {
        return School(id: 0, name: "Newton South High School")
    }
}
