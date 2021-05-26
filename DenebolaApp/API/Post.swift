//
//  Post.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation
import SwiftDate

struct Post: Codable, Equatable, Identifiable {
    let id: Int
    let date: String
    let date_gmt: String?
    let status: String?
    let type: String?
    let link: String?
    let title: RenderHTML
    let content: Render
    let excerpt: RenderHTML
    let attachments: [SimpleMedia]?
    let author: Int?
    let featured_media: Int
    let categories: Set<Int>?
    let _embedded: Embeded?
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getAuthor() -> String {
        return self._embedded!.author![0].name!
    }
    
    func getDate() -> String {
        self.date.toISODate()?.toFormat(DATE_FORMAT) ?? self.date
    }
    
    func getFeaturedImageUrl() -> URL? {
        return self._embedded?.featuredMedia?[0].source_url?.asURL
    }
    
    func getHtmlContent() -> String {
        return """
            <!DOCTYPE HTML>
            <head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></meta></head>
            <html>
                <style>
                    body {
                        font-family: -apple-system, "Helvetica Neue", "Lucida Grande";
                        font-size: "Large";
                    }
                    .blocks-gallery-grid { /* For photo galleries don't display bullets */
                        list-style-type: none;
                    }
                    * {
                        max-width: 100%;
                        height: auto;
                    }
                </style>
                <body>
                    \(self.content.rendered)
                </body>
            </html>
        """
    }
    
    func getExcerpt() -> String {
        return self.excerpt.rendered
    }
    
    func getTitle() -> String {
        return self.title.rendered
    }
    
    /// Gets a image with the specified size string or the original size if it doesn't exist (might be smaller)
    func getThumbnailSizeUrl(size: String) -> URL? {
        return self._embedded?.featuredMedia?[0].media_details?.getSize(size)?.source_url.asURL ?? self._embedded?.featuredMedia?[0].source_url?.asURL
    }
}

struct Embeded: Codable {
    let author: [Author]?
    let featuredMedia: [SimpleMedia]?
    // let category: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case featuredMedia = "wp:featuredmedia"
        case author
        // case category = "wp:term"
    }
}

struct SimpleMedia: Codable {
    let id: Int?
    let source_url: String?
    let media_details: MediaDetails?
}

struct MediaDetails: Codable {
    let sizes: [String: MediaSize]
    
    func getSize(_ name: String) -> MediaSize? {
        return self.sizes[name]
    }
}

struct MediaSize: Codable {
    let source_url: String
}

struct Author: Codable {
    let id: Int?
    let name: String?
}

struct RenderHTML: Codable {
    let rendered: String
    let originalContent: String

    enum CodingKeys: CodingKey {
        case rendered
    }
    
    init(rendered: String) {
        self.rendered = rendered
        self.originalContent = rendered
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalContent = try container.decode(String.self, forKey: .rendered)
        self.rendered = self.originalContent.html2AttributedString!
    }
}

struct Render: Codable {
    let rendered: String
}
