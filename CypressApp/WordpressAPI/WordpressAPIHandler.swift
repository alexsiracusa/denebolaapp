//
//  APIHandler.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation
import SwiftUI

class WordpressAPIHandler: ObservableObject {
    @Published var domain: String
    
    init(domain: String = "https://nshsdenebola.com") {
        self.domain = domain
    }
    
    // done
    func loadPost(_ id: Int, embed: Bool, completionHandler: @escaping (Post?, String?) -> Void) {
        var url = domain + "/wp-json/wp/v2/posts/" + "\(id)"
        if embed { url += "?_embed" }
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // not used
    func loadMedia(_ id: Int, completionHandler: @escaping (Media?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/media/" + "\(id)"
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // not used
    func loadCategory(_ id: Int, completionHandler: @escaping (Category?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/categories/" + "\(id)"
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // not used
    func loadCategoryList(page: Int = 1, per_page: Int = 100, embed: Bool, completionHandler: @escaping ([Category]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/categories"
        url += "&page=\(page)"
        url += "&per_page=\(per_page)"
        if embed { url += "&_embed" }
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // done
    func loadPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, embed: Bool, completionHandler: @escaping ([Post]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/posts"
        url += "&per_page=\(per_page)"
        if let category = category { url += "&categories=\(category)" }
        url += "&page=\(page)"
        if embed { url += "&_embed" }
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // done
    func searchPosts(category: Int? = nil, text: String, page: Int = 1, per_page: Int = 10, embed: Bool = false, completion: @escaping ([Post]?, String?) -> Void) {
        var url = domain + "/wp-json/wp/v2/posts?"
        url += "per_page=\(per_page)"
        url += "&page=\(page)"
        url += "&search="
        url += text.words.flatMap { $0 + "," }
        if let category = category { url += "&filter[cat]=\(category)" }
        if embed { url += "&_embed" }
        JSONLoader.decodeJSON(url: url, completionHandler: completion)
    }
    
    // not used
    func loadAttachmentsForPost(_ id: Int, completionHandler: @escaping ([SimpleMedia]?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/media/?parent=" + "\(id)"
        JSONLoader.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    // not used
    func loadFullPost(_ id: Int, embed: Bool, completionHandler: @escaping (Post?, Media?, URL?, String?) -> Void) {
        // loading post
        loadPost(id, embed: embed) { post, error in
            guard let post = post, error == nil else {
                completionHandler(nil, nil, nil, error)
                return
            }
            let mediaID = post.featured_media
            guard mediaID != 0 else {
                completionHandler(post, nil, nil, error)
                return
            }
            
            // loading media
            self.loadMedia(mediaID) { media, error in
                guard let media = media, error == nil else {
                    completionHandler(post, nil, nil, error)
                    return
                }
                
                completionHandler(post, media, media.source_url.asURL, error)
            }
        }
    }
}

extension String {
    var words: [String] {
        return split(separator: " ").map { String($0) }
    }
}


enum JSONLoader {
    static func loadData(url: URL, completionHandler: @escaping (Data?, String?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            // check for errors
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    let error = "Fetch failed: \(error!)"
                    completionHandler(nil, error)
                }
                return
            }
            completionHandler(data, nil)
        }
        
        task.resume()
    }
    
    static func loadImage(url: URL, completion: @escaping (Image?, String?) -> Void) {
        JSONLoader.loadData(url: url) { data, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, "Bad Data")
                return
            }
            guard let uiImage = UIImage(data: data) else {
                completion(nil, "could not convert to image")
                return
            }
            let image = Image(uiImage: uiImage)
            completion(image, error)
        }
    }
    
    static func decodeJSON<ResponseType: Codable>(url: String, completionHandler: @escaping (ResponseType?, String?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil, "Fetch failed: Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            // check for errors
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    let error = "Fetch failed: \(error!)"
                    completionHandler(nil, error)
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ResponseType.self, from: data)
                // have good data
                DispatchQueue.main.async {
                    completionHandler(result, nil)
                }
                return
            } catch {
                // could not convert data
                DispatchQueue.main.async {
                    let error = "Fetch failed: could not decode json. Reason: \(error)"
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
