//
//  RSSLoader.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import Foundation
import FeedKit

class RSSLoader {
    
    private static func getRSS(_ url: URL, completion: @escaping (Result<Feed, ParserError>) -> Void) -> FeedParser {
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            completion(result)
        }
        return parser
    }
    
    static func loadPodcast(_ url: String, completion: @escaping (Result<LoadedPodcast, RSSError>) -> Void) -> FeedParser? {
        guard let url = URL(string: url) else {
            completion(.failure(RSSError(kind: .urlError, errorDescription: "Invalid URL")))
            return nil
        }
        return RSSLoader.getRSS(url) { result in
            switch result {
            case .success(let feed):
                let _ = feed
                switch feed {
                case .atom:
                    completion(.failure(RSSError(kind: .parseError, errorDescription: "Data is of type ATOM, not RSS")))
                case .json:
                    completion(.failure(RSSError(kind: .parseError, errorDescription: "Data is of type JSON, not RSS")))
                case .rss(let rss):
                    guard let podcast = LoadedPodcast.fromRSS(rss) else {
                        completion(.failure(RSSError(kind: .parseError, errorDescription: "Data could not be converted")))
                        return
                    }
                    completion(.success(podcast))
                }
            case .failure(let error):
                completion(.failure(RSSError(kind: .parseError, errorDescription: error.localizedDescription)))
            }
        }
    }
}

struct LoadedPodcast {
    let title: String
    let description: String
    let titleImageURL: URL?
    let episodes: [PodcastEpisode]
    
    static func fromRSS(_ rss: RSSFeed) -> LoadedPodcast? {
        guard let title = rss.title else { return nil }
        guard let description = rss.description else { return nil }
        var imageURLString = ""
        if let imageURL = rss.image?.url {
            imageURLString = imageURL
        } else if let imageURL = rss.iTunes?.iTunesImage?.attributes?.href {
            imageURLString = imageURL
        } else {
            return nil
        }
        guard let imageURL = URL(string: imageURLString) else { return nil }
        guard let items = rss.items else { return nil }
        var optionalEpisodes: [PodcastEpisode?] = items.map({PodcastEpisode.fromRSSItem($0)})
        optionalEpisodes.removeAll(where: {$0 == nil})
        let episodes = optionalEpisodes.map({$0!})
        return LoadedPodcast(title: title, description: description, titleImageURL: imageURL, episodes: episodes)
    }
}

struct RSSError: Error {
    enum ErrorKind {
        case parseError
        case urlError
    }
    let kind: ErrorKind
    let errorDescription: String
}
