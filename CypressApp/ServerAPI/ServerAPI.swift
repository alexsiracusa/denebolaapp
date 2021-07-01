//
//  ServerAPIHandler.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Alamofire
import Foundation
import SwiftDate

var policy = RetryPolicy(retryLimit: 5, exponentialBackoffBase: 3, exponentialBackoffScale: 0)

let SERVER_URL = "https://cypress.sequal.xyz"

enum ServerAPI {
    static func getSchools(completion: @escaping (Result<[School], AFError>) -> Void) -> Request {
        return AF.request("\(SERVER_URL)/schools", method: .get, interceptor: Retry()).responseDecodable(of: [School].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
}

struct School: Codable, Identifiable {
    let id: Int
    let name: String

    func getConfig(completion: @escaping (Result<SchoolConfig, AFError>) -> Void) -> Request {
        return AF.request("\(SERVER_URL)/schools/\(id)/config", method: .get, interceptor: Retry()).validate().responseDecodable(of: SchoolConfig.self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    func absences(completion: @escaping (Result<[Absence], AFError>) -> Void) -> Request {
        return AF.request("\(SERVER_URL)/schools/\(id)/absences", method: .get, interceptor: Retry()).validate().responseDecodable(of: [Absence].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    func blocks(completion: @escaping (Result<[BlockData], AFError>) -> Void) -> Request {
        return AF.request("\(SERVER_URL)/schools/\(id)/schedule/blocks", method: .get, interceptor: Retry()).validate().responseDecodable(of: [BlockData].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    func getWeek(date: Date, completion: @escaping (Result<Week, AFError>) -> Void) -> Request {
        let dateString = DateInRegion(date, region: .local).toFormat("yyyy-MM-dd")
        return AF.request("\(SERVER_URL)/schools/\(id)/schedule/weeks/\(dateString)", method: .get, interceptor: Retry()).validate().responseDecodable(of: Week.self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    static var `default`: School {
        return School(id: 0, name: "Newton South High School")
    }
}
