//
//  ServerAPIHandler.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation
import Alamofire

var policy = RetryPolicy(retryLimit: 5, exponentialBackoffBase: 3, exponentialBackoffScale: 0)

class ServerAPI {
    static func getSchools(completion: @escaping (Result<[School], AFError>) -> Void) -> Request {
        return AF.request("https://cypress.sequal.xyz/schools", method: .get, interceptor: Retry()).responseDecodable(of: [School].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
    
}

struct School: Codable, Identifiable {
    let id: Int
    let name: String
    
    func getConfig(completion: @escaping (Result<SchoolConfig, AFError>) -> Void) -> Request {
        return AF.request("https://cypress.sequal.xyz/schools/\(id)/config", method: .get, interceptor: Retry()).validate().responseDecodable(of: SchoolConfig.self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
}

