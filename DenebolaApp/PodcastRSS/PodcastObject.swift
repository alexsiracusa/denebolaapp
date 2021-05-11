//
//  PodcastObject.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import Foundation

class PodcastObject: ObservableObject {
    @Published var id = UUID()
    @Published var title: String
    @Published var description: String
    @Published var date: String
    @Published var imageURL: URL?
    @Published var audioURL: URL?
    
    init(title: String, description: String, date: String, imageURL: URL? = nil, audioURL: URL? = nil) {
        self.title = title
        self.description = description
        self.date = date
        self.imageURL = imageURL
        self.audioURL = audioURL
    }
}
