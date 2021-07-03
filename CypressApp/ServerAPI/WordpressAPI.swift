//
//  WordpressAPI.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/9/21.
//

import Alamofire
import Foundation
import PromiseKit

extension Wordpress {
    static func == (lhs: Wordpress, rhs: Wordpress) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    func getPost(_ id: Int, embed: Bool) -> Promise<Post> {
        let params: [String: String] = [
            "_embed": embed ? "true" : "false",
        ]
        return Promise { seal in
            AF.request("\(url)/wp-json/wp/v2/posts/\(id)", method: .get, parameters: params, interceptor: Retry()).validate().responseDecodable(of: Post.self) { response in
                sealResult(seal, response.result)
            }
        }
    }

    func getPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, embed: Bool) -> CancellablePromise<[Post]> {
        var params: [String: String] = [
            "page": "\(page)",
            "per_page": "\(per_page)",
            "_embed": embed ? "true" : "false",
        ]
        if let cat = category { params["categories"] = "\(cat)" }

        let request = AF.request("\(url)/?rest_route=/wp/v2/posts", method: .get, parameters: params, interceptor: Retry()).validate()

        return Promise(cancellable: request) { seal in
            request.responseDecodable(of: [Post].self) { response in
                sealResult(seal, response.result)
            }
        }.cancellize()
    }

    func searchPosts(category: Int? = nil, text: String, page: Int = 1, per_page: Int = 10, embed: Bool = false) -> CancellablePromise<[Post]> {
        var params: [String: String] = [
            "page": "\(page)",
            "per_page": "\(per_page)",
            "search": text.words.joined(separator: ","),
            "_embed": embed ? "true" : "false",
        ]
        if let category = category { params["filter[cat]"] = "\(category)" }
        
        let request = AF.request("\(url)/?rest_route=/wp/v2/posts", method: .get, parameters: params, interceptor: Retry()).validate()
        
        return Promise(cancellable: request) { seal in
            request.responseDecodable(of: [Post].self) { response in
                sealResult(seal, response.result)
            }
        }.cancellize()
    }
}
