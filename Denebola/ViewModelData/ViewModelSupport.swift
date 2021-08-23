//
//  ViewModelSupport.swift
//  CypressApp
//
//  Created by Alex Siracusa on 8/19/21.
//

import Foundation

extension ViewModelData {
    func isPodcastLoaded(_ podcast: Podcast) -> Bool {
        return loadedPodcasts[podcast.id] != nil
    }

    func logo(from url: URL) -> SiteLogo? {
        for site in sites {
            if url.absoluteString.contains(site.url) {
                return SiteLogo(url: site.logoURL)
            }
        }
        return nil
    }
}
