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
                title = data
            } else if elementName == "description" {
                descrip = data
            } else if elementName == "pubDate" {
                date = data
            }
        }
    }
}

struct PodcastData: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var date: String
    var imageURL: URL?
    var audioURL: URL?
    
    static func ==(lhs: PodcastData, rhs: PodcastData?) -> Bool {
        guard let rhs = rhs else {return false}
        return lhs.id == rhs.id
    }
    
    static func !=(lhs: PodcastData, rhs: PodcastData?) -> Bool {
        return !(lhs == rhs)
    }
    
    static var `default`: PodcastData {
        let imageURL = URL(string: "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg")
        let audioURL = URL(string: "https://anchor.fm/s/f635e84/podcast/play/32773030/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2021-4-4%2F182526282-44100-2-80c111c8f86be.m4a")
        return PodcastData(title: "S3E3 - April vacation recap, 4 days a week in person, spring sports, and tik tok drama.", description: "On this weeks episode Freshman Neil Giesser joins the show to talk about his first year at South. Senior Jaden Friedman gives some nfl draft predictions. And the show is wrapped up with our take on tik tok and YouTube news.", date: "Tue, 04 May 2021 01:04:27 GMT", imageURL: imageURL, audioURL: audioURL)
    }
    
}
