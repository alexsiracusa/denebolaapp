//
//  WordpressAPI.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/9/21.
//

import Alamofire
import Foundation

extension Wordpress {
    static func == (lhs: Wordpress, rhs: Wordpress) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    func getPost(_ id: Int, embed: Bool, completion: @escaping (Result<Post, AFError>) -> Void) -> Request {
        let parms: [String: String] = [
            "_embed": embed ? "true" : "false",
        ]
        return AF.request("\(url)/wp-json/wp/v2/posts/\(id)", method: .get, parameters: parms, interceptor: Retry()).validate().responseDecodable(of: Post.self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    func getPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, embed: Bool, completion: @escaping (Result<[Post], AFError>) -> Void) -> Request {
        var parms: [String: String] = [
            "page": "\(page)",
            "per_page": "\(per_page)",
            "_embed": embed ? "true" : "false",
        ]
        if let cat = category { parms["categories"] = "\(cat)" }
        return AF.request("\(url)/?rest_route=/wp/v2/posts", method: .get, parameters: parms, interceptor: Retry()).validate().responseDecodable(of: [Post].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }

    func searchPosts(category: Int? = nil, text: String, page: Int = 1, per_page: Int = 10, embed: Bool = false, completion: @escaping (Result<[Post], AFError>) -> Void) -> Request {
        var parms: [String: String] = [
            "page": "\(page)",
            "per_page": "\(per_page)",
            "search": text.words.joined(separator: ","),
            "_embed": embed ? "true" : "false",
        ]
        if let category = category { parms["filter[cat]"] = "\(category)" }
        return AF.request("\(url)/?rest_route=/wp/v2/posts", method: .get, parameters: parms, interceptor: Retry()).validate().responseDecodable(of: [Post].self) { response in
            completion(response.result)
            print(response.request!.url!.absoluteString)
        }
    }
}
