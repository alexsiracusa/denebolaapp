//
//  Wordpress.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/9/21.
//

import Foundation

struct Wordpress: Codable, Identifiable, Hashable {
    let id: Int
    let enabled: Bool
    let url: String
    let name: String
    let featuredCategories: [SimpleCategory]
    let logo: ImageData
    let defaultImage: ImageData
    let logoBanner: ImageData

    var logoURL: URL {
        return try! logo.url.asURL()
    }

    var defaultImageURL: URL {
        return try! defaultImage.url.asURL()
    }
    
    var bannerURL: URL {
        return try! logoBanner.url.asURL()
    }

    static var `default`: Wordpress {
        let categories = [SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil), SimpleCategory(id: 2, name: "Arts", image: nil)]
        // id is -1 as CategoriesView checks that the default wordpress is not loaded
        return Wordpress(id: -1, enabled: true, url: "https://nshsdenebola.com", name: "Denebola", featuredCategories: categories, logo: ImageData(url: "https://drive.google.com/uc?id=10B26RQoXGLEY_ou9NaF4BkbjuP7-SgIj"), defaultImage: ImageData(url: "https://drive.google.com/uc?id=1Omm7YzR6RibN28jhbYuhfHoN3qDGG1Bg"), logoBanner: ImageData(url: "https://drive.google.com/uc?id=1IK_h-xHumI77suWMsaWd0zOmuZU0HD2M"))
    }
}
