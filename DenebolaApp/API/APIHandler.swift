//
//  APIHandler.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation
import SwiftUI

class APIHandler: ObservableObject {
    let domain = "https://nshsdenebola.com"
    
    func loadPost(_ id: Int, embed: Bool, completionHandler: @escaping (Post?, String?) -> Void) {
        var url = domain + "/wp-json/wp/v2/posts/" + "\(id)"
        if embed { url += "?_embed" }
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadMedia(_ id: Int, completionHandler: @escaping (Media?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/media/" + "\(id)"
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadCategory(_ id: Int, completionHandler: @escaping (Category?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/categories/" + "\(id)"
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadCategoryList(page: Int = 1, per_page: Int = 100, embed: Bool, completionHandler: @escaping ([Category]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/categories"
        url += "&page=\(page)"
        url += "&per_page=\(per_page)"
        if embed { url += "&_embed" }
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, embed: Bool, completionHandler: @escaping ([Post]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/posts"
        url += "&per_page=\(per_page)"
        if let category = category { url += "&categories=\(category)" }
        url += "&page=\(page)"
        if embed { url += "&_embed" }
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
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
    
    func loadPostForDisplay(_ id: Int, completionHandler: @escaping (Post?, URL?, String?) -> Void) {
        loadPost(id, embed: true) { post, error in
            guard let post = post, error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            
            guard post.hasMedia else {
                completionHandler(post, nil, error)
                return
            }
            
            let imageUrl = post._embedded?.featuredMedia?[0].source_url?.asURL
            completionHandler(post, imageUrl, error)
        }
    }
    
    func loadData(url: URL, completionHandler: @escaping (Data?, String?) -> Void) {
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
    
    static func decodeJSON<ResponseType: Codable>(url: String, completionHandler: @escaping (ResponseType?, String?) -> Void) {
        guard let url = URL(string: url) else { return }
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
            
            if let result = try? JSONDecoder().decode(ResponseType.self, from: data) {
                // have good data
                DispatchQueue.main.async {
                    completionHandler(result, nil)
                }
                return
            } else {
                // could not convert data
                DispatchQueue.main.async {
                    let error = "Fetch failed: could not decode json"
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
