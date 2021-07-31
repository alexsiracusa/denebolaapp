//
//  TabCreator.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation

extension SchoolConfig {
    func homeTab() -> HomeTab? {
        guard let home = home, home.enabled else { return nil }
        // TODO: fix these unwraps
        return HomeTab(sites: wordpress!, podcasts: podcasts!)
    }

    func podcastsTab() -> PodcastTab? {
        guard var podcasts = podcasts else { return nil }
        podcasts = podcasts.filter { $0.enabled }
        guard podcasts.count > 0 else { return nil }
        return PodcastTab(podcasts: podcasts)
    }

    func feedTab() -> FeedTab? {
        guard let wordpress = wordpress else { return nil }
        let sites = wordpress.filter { $0.enabled }
        guard sites.count > 0 else { return nil }
        return FeedTab(sites: wordpress)
    }

    func scheduleTab() -> SocialTab? {
        guard let schedule = schedule, schedule.enabled else { return nil }
        return SocialTab()
    }

    func allTabs() -> [Tab] {
        var tabs = [Tab]()

        if let home = homeTab() { tabs.append(home) }

        if let feed = feedTab() {
            tabs.append(feed)
        }

        if let podcast = podcastsTab() { tabs.append(podcast) }

        if let schedule = scheduleTab() { tabs.append(schedule) }

        return tabs
    }
}
