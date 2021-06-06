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

struct Wordpress: Codable, Identifiable, Hashable {
    static func == (lhs: Wordpress, rhs: Wordpress) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    let id: Int
    let enabled: Bool
    let url: String
    let name: String
    let featuredCategories: [SimpleCategory]
    let logo: ImageData
    let defaultImage: ImageData

    var logoURL: URL? {
        return URL(string: logo.url)
    }

    var defaultImageURL: URL? {
        return URL(string: defaultImage.url)
    }

    static var `default`: Wordpress {
        let categories = [SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil)]
        return Wordpress(id: 0, enabled: true, url: "https://nshsdenebola.com", name: "Denebola", featuredCategories: categories, logo: ImageData(url: "https://drive.google.com/uc?id=10B26RQoXGLEY_ou9NaF4BkbjuP7-SgIj"), defaultImage: ImageData(url: "https://drive.google.com/uc?id=1Omm7YzR6RibN28jhbYuhfHoN3qDGG1Bg"))
    }
}

struct SimpleCategory: Codable, Identifiable {
    let id: Int
    let name: String
    var image: ImageData?

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

struct Podcast: Codable {
    let id: Int
    let enabled: Bool
    let rssUrl: String
}

struct Home: Codable {
    let id: Int
    let enabledSections: [String]
}

struct Announcement: Codable {}
