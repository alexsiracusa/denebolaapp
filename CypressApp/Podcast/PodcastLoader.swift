//
//  PodcastLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import Foundation
import FeedKit

class PodcastLoader: ObservableObject {
    var feeds: [String]
    @Published var loadedFeeds: [LoadedPodcast]
    
    init(_ feeds: [String]) {
        self.feeds = feeds
        self.loadedFeeds = []
        for _ in 0..<feeds.count {
            let n = LoadedPodcast.empty()
            loadedFeeds.append(n)
        }
        //self.loadedFeeds = Array(repeating: LoadedPodcast.empty(), count: feeds.count)
        loadPodcasts()
    }
    
    private var parsers: [FeedParser?] = []
    
    func loadPodcasts() {
        for (index, rssURL) in feeds.enumerated() {
            if !loadedFeeds[index].isEmpty() {
                break
            }
            parsers.append(RSSLoader.loadPodcast(rssURL) { result in
                switch result {
                case .success(let podcast):
                    DispatchQueue.main.async {
                        self.loadedFeeds[index] = podcast
                    }
                case .failure(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.loadPodcasts()
                    }
                }
            })
        }
    }
    
    func setFeeds(_ feeds: [String]) {
        for parser in parsers {
            parser?.abortParsing()
        }
        parsers = []
        self.feeds = feeds
        self.loadedFeeds = []
        for _ in 0..<feeds.count {
            let n = LoadedPodcast.empty()
            loadedFeeds.append(n)
        }
        //self.loadedFeeds = Array(repeating: LoadedPodcast.empty(), count: feeds.count)
        loadPodcasts()
    }
}
