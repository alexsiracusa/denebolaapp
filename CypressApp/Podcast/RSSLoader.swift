//
//  RSSLoader.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import FeedKit
import Foundation
import SwiftDate

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

struct LoadedPodcast: Identifiable {
    var id = UUID()

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
        var optionalEpisodes: [PodcastEpisode?] = items.map { PodcastEpisode.fromRSSItem($0, defaultImage: imageURL) }
        optionalEpisodes.removeAll(where: { $0 == nil })
        let episodes = optionalEpisodes.map { $0! }
        return LoadedPodcast(title: title, description: description, titleImageURL: imageURL, episodes: episodes)
    }

    static var `default`: LoadedPodcast {
        return LoadedPodcast(title: "Denebocast: The Newton South Podcast", description: "Hello! Aidan, Brendan, and Justin here from Denebocast: Newton South's premier news podcast. The three of us are close friends who share a passion for journalism and current events. On this show, we present students with information that they should know going into each week. As current high schoolers, we provide a peer-based approach, reporting on news, both local and national, in an interesting, conversational setting. Feel free to email us at denebolapod@gmail.com if you have any questions, comments, or requests for us to cover", titleImageURL: URL(string: "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg"), episodes: [PodcastEpisode(title: "Denebocast - S3E5 Media, where do we draw the line? With Mr.Weintraub", description: "In this week’s episode we talk to our English teacher about his experience teaching this year, and his love of media! Near the end of the show we talk about the good and bad of media.", date: DateInRegion(), imageURL: URL(string: "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg"), audioURL: URL(string: "https://anchor.fm/s/f635e84/podcast/play/35085052/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2021-5-8%2F194756451-44100-2-d848eddb3e298.mp3"))])
    }

//    static var empty: LoadedPodcast {
//        return LoadedPodcast(id: UUID(), title: String(), description: "", titleImageURL: nil, episodes: [])
//    }
    
    private static var nextId = UUID()
    static func empty() -> LoadedPodcast {
        LoadedPodcast.nextId = UUID()
        return LoadedPodcast(id: nextId, title: String(), description: "", titleImageURL: nil, episodes: [])
    }

    func isEmpty() -> Bool {
        return self.title.isEmpty
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
