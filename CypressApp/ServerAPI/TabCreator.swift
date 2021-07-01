//
//  TabCreator.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation

extension SchoolConfig {
    func homeTab() -> HomeTab? {
        return HomeTab(sites: wordpress, podcasts: podcasts)
    }

    func podcastsTab() -> PodcastTab? {
        let podcasts = self.podcasts.filter { $0.enabled }
        guard podcasts.count > 0 else { return nil }
        return PodcastTab(podcasts: podcasts)
    }

    func feedTab() -> FeedTab? {
        let sites = wordpress.filter { $0.enabled }
        guard sites.count > 0 else { return nil }
        return FeedTab(sites: wordpress)
    }

    func scheduleTab() -> ScheduleTab? {
        guard home.enabledSections.contains("schedule") else { return nil }
        return ScheduleTab()
    }

    func allTabs(modelData: ViewModelData) -> [Tab] {
        var tabs = [Tab]()

        if let home = homeTab() { tabs.append(home) }

        if let feed = feedTab() {
            tabs.append(feed)
            // selectedWordpress is implicitly unwrapped - the feedtab is the first tab that uses it so we set it now
            modelData.selectedWordpress = wordpress[0]
        }

        if let podcast = podcastsTab() { tabs.append(podcast) }

        if let schedule = scheduleTab() { tabs.append(schedule) }

        return tabs
    }
}
