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
    
    func loadPost(_ id: Int, completionHandler: @escaping (Post?, String?) -> Void) {
        let url = domain + "/wp-json/wp/v2/posts/" + "\(id)"
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
    
    func loadCategoryList(page: Int = 1, per_page: Int = 100, completionHandler: @escaping ([Category]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/categories"
        url += "&page=\(page)"
        url += "&per_page=\(per_page)"
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadPostPage(category: Int? = nil, page: Int = 1, per_page: Int = 10, completionHandler: @escaping ([Post]?, String?) -> Void) {
        var url = domain + "/?rest_route=/wp/v2/posts"
        url += "&per_page=\(per_page)"
        if let category = category {url += "&categories=\(category)"}
        url += "&page=\(page)"
        APIHandler.decodeJSON(url: url, completionHandler: completionHandler)
    }
    
    func loadFullPost(_ id: Int, completionHandler: @escaping (Post?, Media?, Image?, String?) -> Void) {
        // loading post
        loadPost(id) { post, error in
            guard let post = post, error == nil else {
                completionHandler(nil, nil, nil, error)
                return
            }
            let mediaID = post.featured_media
            guard mediaID != 0  else {
                completionHandler(post, nil, nil, error)
                return
            }
            
            // loading media
            self.loadMedia(mediaID) { media, error in
                guard let media = media, error == nil else {
                    completionHandler(post, nil, nil, error)
                    return
                }
                let url = media.source_url
                
                // loading image
                self.loadImage(url) { image, error in
                    guard let image = image, error == nil else {
                        completionHandler(post, nil, nil, error)
                        return
                    }
                    completionHandler(post, media, image, error)
                }
            }
        }
    }
    
    func loadImage(_ url: String, completionHandler: @escaping (Image?, String?) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    let error = "Fetch failed: \(error!)"
                    completionHandler(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    let error = "Fetch failed: could not convert to image"
                    completionHandler(nil, error)
                    return
                }
                completionHandler(Image(uiImage: uiImage), nil)
            }
        }
        task.resume()
    }
    
    static func decodeJSON<ResponseType:Codable>(url: String, completionHandler: @escaping (ResponseType?, String?) -> Void) {
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //check for errors
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
