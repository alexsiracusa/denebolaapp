//
//  PodcastLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import FeedKit
import Foundation
import PromiseKit

class PodcastLoader: ObservableObject {
    var feeds: [String]
    @Published var loadedFeeds: [LoadedPodcast]

    init(_ feeds: [String]) {
        self.feeds = feeds
        loadedFeeds = []

        // don't remove this, it's needed to create unique id's
        for _ in 0 ..< feeds.count {
            loadedFeeds.append(LoadedPodcast.empty())
        }

        loadPodcasts()
    }

    func loadPodcasts() {
        for (index, rssURL) in feeds.enumerated() {
            if !loadedFeeds[index].isEmpty() {
                break
            }

            retry(times: Int.max, cooldown: 2.5) {
                return RSSLoader.loadPodcast(rssURL)
            }.done { podcast in
                self.loadedFeeds[index] = podcast
            }.catch { error in
                print(error)
            }
        }
    }

    func setFeeds(_ feeds: [String]) {
        self.feeds = feeds
        loadedFeeds.removeAll()

        // don't remove this, it's needed to create unique id's
        for _ in 0 ..< feeds.count {
            loadedFeeds.append(LoadedPodcast.empty())
        }

        loadPodcasts()
    }

    static var `default`: PodcastLoader {
        PodcastLoader(["https://atp.fm/rss"])
    }
}
