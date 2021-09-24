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

    func handleError(context: String? = nil) -> (_ error: Error) -> Void {
        // REDIRECT ALL ERRORS TO HERE
        return { error in
            print("ERROR OCCURED: \(context) - \(error.localizedDescription)")
        }
    }

    func getRefreshModifier(for name: String, callback: @escaping RefreshCallback) -> PullRefresh {
        if self.refreshObservers[name] == nil {
            self.refreshObservers[name] = PullRefresh(callback)
        }
        return self.refreshObservers[name]!
    }
}
