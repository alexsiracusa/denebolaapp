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
    
    func load() {
        guard let url = URL(string: rss) else {return}
        loadFeed(url: url) { podcast, error in
            
        }
    }
    
    private func loadFeed(url: URL, completion: @escaping (Podcast?, String?) -> Void) {
        let parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "book" {
            title = String()
            //bookAuthor = String()
        }

        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" {
            let podcast = Podcast(title: title)
            podcasts.append(podcast)
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                title += data
            } else if self.elementName == "author" {
                //bookAuthor += data
            }
        }
    }
    
}

struct Podcast: Identifiable {
    var id: Int {title!.hash}
    var title: String?
    var author: String?
    var description: String?
    var primaryGenre: String?
    var artworkURL: URL?
}


