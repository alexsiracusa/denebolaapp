//
//  Post.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation
import PromiseKit
import SwiftDate

struct Post: Codable, Equatable, Identifiable {
    let id: Int
    let date: String
    let date_gmt: String?
    let status: String?
    let type: String?
    let link: URL
    let title: RenderHTML
    let content: Render
    let excerpt: RenderHTML
    let attachments: [SimpleMedia]?
    let author: Int?
    let featured_media: Int
    let categories: Set<Int>?
    let _embedded: Embeded?

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }

    func getAuthor() -> String {
        return _embedded?.author?[0].name ?? ""
    }

    func getDate() -> String {
        date.toISODate()?.toFormat(DATE_FORMAT) ?? date
    }

    func getDateRelative() -> String {
        date.toISODate()?.toRelative() ?? getDate()
    }

    func getFeaturedImageUrl() -> URL? {
        return try? _embedded?.featuredMedia?[0].source_url?.asURL()
    }

    func getHtmlContent() -> Promise<String?> {
        return extractArticleFromUrl(url: link).map {
            $0.map { elements in
                generateHtml(head: elements.head, body: [elements.scripts, elements.styles, self.content.rendered])
            }
        }
    }

    func getExcerpt() -> String {
        return excerpt.rendered
    }

    func getTitle() -> String {
        return title.rendered
    }

    func getDomain() -> URL {
        return try! link.relativePath.asURL()
    }

    /// Gets a image with the specified size string or the original size if it doesn't exist (might be smaller)
    func getThumbnailSizeUrl(size: String) -> URL? {
        return try? _embedded?.featuredMedia?[0].media_details?.getSize(size)?.source_url.asURL() ?? _embedded?.featuredMedia?[0].source_url?.asURL()
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
        return sizes[name]
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

    enum CodingKeys: CodingKey {
        case rendered
    }

    init(rendered: String) {
        self.rendered = rendered
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rendered = try container.decode(String.self, forKey: .rendered).html2AttributedString!
    }
}

struct Render: Codable {
    let rendered: String
}
