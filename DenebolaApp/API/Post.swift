//
//  Post.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation

struct Post: Codable, Equatable, Identifiable {
    let id: Int
    let date: String
    let date_gmt: String
    let status: String
    let type: String
    let link: String
    let title: Render
    let content: Render
    let excerpt: Render
    let author: Int
    let featured_media: Int
    let categories: [Int]
    let _embedded: Embeded?
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    var renderedContent: String {
        return content.rendered.html2AttributedString!
            .replacingOccurrences(of: "\n", with: "\n\n")
    }
    
    var renderedExcerpt: String {
        return excerpt.rendered.html2AttributedString!
    }
    
    var renderedTitle: String {
        return title.rendered.html2AttributedString!
    }
}

struct Embeded: Codable {
    let author: Author?
    let featuredMedia: [Media]?
    //let category: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case featuredMedia = "wp:featuredmedia"
        case author = "author"
        //case category = "wp:term"
    }
}

struct Author: Codable {
    
}

struct Render: Codable {
    let rendered: String
}

extension String {
    var html2AttributedString: String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
            //return self

        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
}



