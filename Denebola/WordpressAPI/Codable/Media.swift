//
//  Media.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation

struct Media: Codable, Equatable, Identifiable {
    let id: Int
    let date: String
    let date_gmt: String?
    let status: String?
    let type: String
    let link: String
    let title: Render
    let author: Int
    let description: Render?
    let caption: Render
    let media_type: String
    let mime_type: String
    let media_details: Media_Details
    let post: Int?
    let source_url: String

    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Media_Details: Codable {
    let width: Int
    let height: Int
    let file: String
    let sizes: Sizes
}

struct Sizes: Codable {
    let thumbnail: Size?
    let medium: Size?
    let medium_large: Size?
    let large: Size?
    let full: Size
}

struct Size: Codable {
    let file: String
    let width: Int
    let height: Int
    let mime_type: String
    let source_url: String
}
