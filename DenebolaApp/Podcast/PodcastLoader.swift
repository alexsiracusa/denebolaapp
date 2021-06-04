//
//  PodcastLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import Foundation

class PodcastLoader: NSObject, ObservableObject, XMLParserDelegate {
    let rss = "https://anchor.fm/s/f635e84/podcast/rss"
    @Published var podcasts: [PodcastData] = []
    @Published var time = 0.0
    @Published var loaded = false
    var elementName = String()
    var title = String()
    var imageURL = String()
    var audioURL = String()
    var descrip = String()
    var date = String()
    
    var podcastTitle = String()
    var podcastDiscription = String()
    var podcastImageURL = String()
    
    var onEnd: ([PodcastData]) -> Void = {_ in }
    func parserDidEndDocument(_ parser: XMLParser) {
        onEnd(podcasts)
    }

    func load(completion: @escaping ([PodcastData]) -> Void) {
        guard let url = URL(string: rss) else { return }
        onEnd = completion
        podcasts = []
        loadFeed(url: url)
        loaded = true
    }

    private func loadFeed(url: URL) {
        let parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }

    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName == "enclosure" {
            let attrsUrl = attributeDict as [String: NSString]
            let auidoURL = attrsUrl["url"]
            audioURL = auidoURL! as String
        }
        if elementName == "itunes:image" {
            let attrsUrl = attributeDict as [String: NSString]
            let imageURL = attrsUrl["href"]
            self.imageURL = imageURL! as String
        }
        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let imageURL = URL(string: self.imageURL)
            let audioURL = URL(string: self.audioURL)
            let podcast = PodcastData(title: title, description: descrip, date: date, imageURL: imageURL, audioURL: audioURL)
            podcasts.append(podcast)
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if !data.isEmpty {
            if elementName == "title" {
                if podcastTitle.isEmpty {
                    podcastTitle = data
                }
                title = data
            } else if elementName == "description" {
                if podcastDiscription.isEmpty {
                    podcastDiscription = data.replacingOccurrences(of: "\n", with: " ")
                }
                descrip = data
            } else if elementName == "pubDate" {
                date = data
            } else if elementName == "url" {
                podcastImageURL = data
            }
        }
    }
}