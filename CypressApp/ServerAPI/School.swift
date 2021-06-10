//
//  School.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation

struct School: Codable {
    let announcements: Announcement
    let home: Home
    let podcasts: [Podcast]
    let wordpress: [Wordpress]
}

struct SimpleCategory: Codable, Identifiable {
    let id: Int
    let name: String
    let image: ImageData?

    var imageURL: URL? {
        guard let image = image else { return nil }
        return URL(string: image.url)
    }

    func hasImage() -> Bool {
        return image != nil
    }
}

struct ImageData: Codable {
    let url: String
}

struct Podcast: Codable, Identifiable, Hashable {
    let id: Int
    let enabled: Bool
    let rssUrl: String
    
    static var `default`: Podcast {
        return Podcast(id: 0, enabled: true, rssUrl: "https://anchor.fm/s/f635e84/podcast/rss")
    }
}

struct Home: Codable {
    let id: Int
    let enabledSections: [String]
}

struct Announcement: Codable {}
