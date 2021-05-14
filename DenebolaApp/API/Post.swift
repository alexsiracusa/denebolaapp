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
    let date_gmt: String?
    let status: String?
    let type: String?
    let link: String?
    let title: Render
    let content: Render
    let excerpt: Render
    let author: Int?
    let featured_media: Int
    let categories: [Int]?
    let _embedded: Embeded?
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func asPostRow(thumbnailSize: String = "medium") -> PostRow {
        return PostRow(id: self.id, title: self.renderedTitle, author: (self._embedded!.author![0].name)!, date: self.renderedDate, fullImageURL: self._embedded?.featuredMedia?[0].source_url?.asURL, thumbnailImageURL: self.getThumbnailSizeUrl(size: thumbnailSize), hasMedia: self.hasMedia)
    }
    
    /// Gets a image with the specified size string or the original size if it doesn't exist (might be smaller)
    func getThumbnailSizeUrl(size: String) -> URL? {
        return self._embedded?.featuredMedia?[0].media_details.getSize(size)?.source_url.asURL ?? self._embedded?.featuredMedia?[0].source_url?.asURL
    }
    
    var renderedContent: String { // TODO: remove?
        return self.content.rendered.html2AttributedString!
            .replacingOccurrences(of: "\n", with: "\n\n")
    }
    
    var renderedExcerpt: String {
        return self.excerpt.rendered.html2AttributedString!
    }
    
    var renderedTitle: String {
        return self.title.rendered.html2AttributedString!
    }
    
    var renderedDate: String {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        date.locale = Locale(identifier: "en_US")
        
        let parsedDate = date.date(from: self.date)!
        date.setLocalizedDateFormatFromTemplate("MMMMdYYYY")
        
        return date.string(from: parsedDate)
    }
    
    var htmlContent: String {
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
    
    var hasMedia: Bool {
        return self.featured_media != 0
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
    let media_details: MediaDetails
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

struct Render: Codable {
    let rendered: String
}
