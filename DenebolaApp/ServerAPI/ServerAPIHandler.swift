//
//  ServerAPIHandler.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation

class ServerAPIHandler: ObservableObject {
    let domain: String
    
    init(_ domain: String = "https://denebola.sequal.xyz") {
        self.domain = domain
    }
    
    func loadSchool(_ id: Int, completion: @escaping (School?, String?) -> ()) {
        let url = domain + "/schools/" + "\(id)" + "/config"
        JSONLoader.decodeJSON(url: url, completionHandler: completion)
    }
}
