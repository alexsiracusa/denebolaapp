//
//  PodcastLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import Foundation

class PodcastLoader: NSObject, ObservableObject, XMLParserDelegate {
    
    let rss = "https://anchor.fm/s/f635e84/podcast/rss"
    @Published var podcasts: [Podcast] = []
    var elementName: String = String()
    var title = String()
    var imageURL = String()
    var audioURL = String()
    var descrip = String()
    
    func load() {
        guard let url = URL(string: rss) else {return}
        podcasts = []
        loadFeed(url: url)
    }
    
    private func loadFeed(url: URL) {
        let parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

//        if elementName == "item" {
//            title = String()
//            //imageURL = String()
//        }
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
            let imageURL = URL(string: imageURL)
            let audioURL = URL(string: audioURL)
            let podcast = Podcast(title: title, description: descrip, imageURL: imageURL, audioURL: audioURL)
            podcasts.append(podcast)
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                title = data
            } else if self.elementName == "description" {
                descrip = data
            }
        }
    }
    
}

struct Podcast: Identifiable {
    var id: Int {title!.hash}
    var title: String?
    var description: String?
    var imageURL: URL?
    var audioURL: URL?
}


