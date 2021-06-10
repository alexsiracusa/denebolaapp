//
//  WordpressAPI.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/9/21.
//

import Foundation
import Alamofire

extension Wordpress {
    static func == (lhs: Wordpress, rhs: Wordpress) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    func getPost(_ id: Int, embed: Bool, completion: @escaping (Result<Post, AFError>) -> Void) {
        let parms: [String: String] = [
            "_embed" : embed ? "true" : "false"
        ]
        AF.request("\(self.url)/wp-json/wp/v2/posts/\(id)", method: .get, parameters: parms).responseDecodable(of: Post.self) { response in
            completion(response.result)
            print(response.request?.url?.absoluteString)
        }
    }
    
    func getPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, embed: Bool, completion: @escaping (Result<[Post], AFError>) -> Void) {
        var parms: [String: String] = [
            "page" : "\(page)",
            "per_page" : "\(per_page)",
            "_embed" : embed ? "true" : "false"
        ]
        if let cat = category { parms["categories"] = "\(cat)" }
        AF.request("\(self.url)/?rest_route=/wp/v2/posts", method: .get, parameters: parms).responseDecodable(of: [Post].self) { response in
            completion(response.result)
            print(response.request?.url?.absoluteString)
        }
    }
    
    func searchPosts(category: Int? = nil, text: String, page: Int = 1, per_page: Int = 10, embed: Bool = false, completion: @escaping (Result<[Post], AFError>) -> Void) {
        var parms: [String : String] = [
            "page" : "\(page)",
            "per_page" : "\(per_page)",
            "search" : String(text.words.flatMap{$0 + ","}),
            "_embed" : embed ? "true" : "false"
        ]
        if let category = category { parms["filter[cat]"] = "\(category)" }
        AF.request("\(self.url)/?rest_route=/wp/v2/posts", method: .get, parameters: parms).responseDecodable(of: [Post].self) { response in
            completion(response.result)
            print(response.request?.url?.absoluteString)
        }
    }
    
    
}
