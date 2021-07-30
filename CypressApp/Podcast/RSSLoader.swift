//
//  RSSLoader.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import FeedKit
import Foundation
import PromiseKit
import SwiftDate

class RSSLoader {
    private static func getFeedParser(_ url: URL) -> Promise<FeedParser> {
        let parser = FeedParser(URL: url)

        return Promise(cancellable: parser) { seal in
            seal.fulfill(parser)
        }
    }

    private static func beginParsing(_ parser: FeedParser) -> Promise<Feed> {
        return Promise { seal in
            sealResult(seal, parser.parse())
        }
    }

    private static func processFeedData(_ feed: Feed) -> Promise<LoadedPodcast> {
        return Promise { seal in
            switch feed {
            case .atom:
                seal.reject(RSSError(kind: .parseError, errorDescription: "Data is of type ATOM, not RSS"))
            case .json:
                seal.reject(RSSError(kind: .parseError, errorDescription: "Data is of type JSON, not RSS"))
            case let .rss(rss):
                guard let podcast = LoadedPodcast.fromRSS(rss) else {
                    seal.reject(RSSError(kind: .parseError, errorDescription: "Data could not be converted"))
                    return
                }
                seal.fulfill(podcast)
            }
        }
    }

    static func loadPodcast(_ url: String) -> Promise<LoadedPodcast> {
        // Convert url string to URL
        return firstly {
            RSSLoader.getFeedParser(try url.asURL())
        }
        // Parse the Feed URL
        .then { parser in
            RSSLoader.beginParsing(parser)
            // Process the feed data
        }.then { feed in
            RSSLoader.processFeedData(feed)
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
        guard let imageURL = try? imageURLString.asURL() else { return nil }
        guard let items = rss.items else { return nil }
        let episodes: [PodcastEpisode] = items.compactMap { PodcastEpisode.fromRSSItem($0, defaultImage: imageURL, from: title) }
        return LoadedPodcast(title: title, description: description, titleImageURL: imageURL, episodes: episodes)
    }

    static var `default`: LoadedPodcast {
        return LoadedPodcast(title: "Denebocast: The Newton South Podcast", description: "Hello! Aidan, Brendan, and Justin here from Denebocast: Newton South's premier news podcast. The three of us are close friends who share a passion for journalism and current events. On this show, we present students with information that they should know going into each week. As current high schoolers, we provide a peer-based approach, reporting on news, both local and national, in an interesting, conversational setting. Feel free to email us at denebolapod@gmail.com if you have any questions, comments, or requests for us to cover", titleImageURL: try? "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg".asURL(), episodes: [PodcastEpisode(title: "Denebocast - S3E5 Media, where do we draw the line? With Mr.Weintraub", description: "In this week’s episode we talk to our English teacher about his experience teaching this year, and his love of media! Near the end of the show we talk about the good and bad of media.", date: DateInRegion(), imageURL: try? "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg".asURL(), audioURL: try? "https://anchor.fm/s/f635e84/podcast/play/35085052/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2021-5-8%2F194756451-44100-2-d848eddb3e298.mp3".asURL(), from: "Denebocast")])
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
        return title.isEmpty
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
