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

    private var parserPromises: [CancellablePromise<LoadedPodcast>] = []

    func loadPodcasts() {
        parserPromises.removeAll()

        for (index, rssURL) in feeds.enumerated() {
            if !loadedFeeds[index].isEmpty() {
                break
            }

            parserPromises.append(RSSLoader.loadPodcast(rssURL))
            parserPromises[index].done { podcast in
                self.loadedFeeds[index] = podcast
            }.catch { _ in
                // TODO: handle error
            }
        }
    }

    func setFeeds(_ feeds: [String]) {
        for parser in parserPromises {
            parser.cancel()
        }

        self.feeds = feeds
        loadedFeeds.removeAll()

        // don't remove this, it's needed to create unique id's
        for _ in 0 ..< feeds.count {
            loadedFeeds.append(LoadedPodcast.empty())
        }

        loadPodcasts()
    }
}
