//
//  ServerAPIHandler.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation
import Alamofire

class ServerAPIHandler: ObservableObject {
    let domain: String

    init(_ domain: String = "https://cypress.sequal.xyz") {
        self.domain = domain
    }

    func loadSchool(_ id: Int, completion: @escaping (SchoolConfig?, String?) -> ()) {
        let url = domain + "/schools/" + "\(id)" + "/config"
        JSONLoader.decodeJSON(url: url, completionHandler: completion)
    }
}

class ServerAPI {
    static func getSchools(completion: @escaping (Result<[School], AFError>) -> Void) -> Request {
        return AF.request("https://cypress.sequal.xyz/schools", method: .get).responseDecodable(of: [School].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
    
}

struct School: Codable {
    let id: Int
    let name: String
    
    func getConfig(completion: @escaping (Result<SchoolConfig, AFError>) -> Void) -> Request {
        return AF.request("https://cypress.sequal.xyz/schools/\(id)/config", method: .get).responseDecodable(of: SchoolConfig.self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
}
