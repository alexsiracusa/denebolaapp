//
//  DefaultImage.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation
import SwiftUI
import Combine

class SiteImages: ObservableObject {
    @Published var defaultImageURL: URL = URL(string: "https://lh3.googleusercontent.com/proxy/RXdtlKqWTwdbnHZ4JEL6j-eezStBHbtX5pS7Sy3mXZu_sV4e3kw8FYYhO6vkv7b5uTOEHa9sJjbSavSaYZsxa7Ih9Ds70g7wGxlZCoH226z7rk4LbYo2WRFeZo7hr4dRaxPgw7ItfbLa")!
    @Published var logoURL: URL = URL(string: "https://lh3.googleusercontent.com/proxy/RXdtlKqWTwdbnHZ4JEL6j-eezStBHbtX5pS7Sy3mXZu_sV4e3kw8FYYhO6vkv7b5uTOEHa9sJjbSavSaYZsxa7Ih9Ds70g7wGxlZCoH226z7rk4LbYo2WRFeZo7hr4dRaxPgw7ItfbLa")! {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    init() {}
    init(_ url: String) {
        guard let url = URL(string: url) else {return}
        self.defaultImageURL = url
    }
}
