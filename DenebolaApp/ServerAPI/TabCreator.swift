//
//  TabCreator.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation

extension School {
    func homeTab() -> HomeTab? {
        //guard home.enabledSections.contains("home") else {return nil}
        return HomeTab()
    }
    
    func podcastsTab() -> PodcastTab? {
        guard home.enabledSections.contains("podcast") else {return nil}
        return PodcastTab()
    }
    
    func feedTab() -> FeedTab? {
        guard home.enabledSections.contains("wordpress") else {return nil}
        return FeedTab(sites: wordpress)
    }
    
    func scheduleTab() -> ScheduleTab? {
        guard home.enabledSections.contains("schedule") else {return nil}
        return ScheduleTab()
    }
    
    func allTabs() -> [Tab] {
        var tabs = [Tab]()
        if let home = homeTab() {tabs.append(home)}
        if let feed = feedTab() {tabs.append(feed)}
        if let podcast = podcastsTab() {tabs.append(podcast)}
        if let schedule = scheduleTab() {tabs.append(schedule)}
        return tabs
    }
}
