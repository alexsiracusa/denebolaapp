//
//  TabManager.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation

class TabManager: ObservableObject {
    var tabs: [Tab] = []
    var home: HomeTab? = HomeTab()
    var feed: FeedTab? = FeedTab()
    var podcast: PodcastTab? = PodcastTab()
    var schedule: ScheduleTab? = ScheduleTab()
    
    var feedStyle: FeedStyle = .normal {
        didSet {
            self.feed?.feedStyle = feedStyle
        }
    }
    var categoriesStyle: CategoriesStyle = .image {
        didSet {
            self.feed?.categoriesStyle = categoriesStyle
        }
    }
    
    init() {
        self.tabs = [home!, feed!, podcast!, schedule!]
    }
}
