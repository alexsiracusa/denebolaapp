//
//  PodcastTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct PodcastTab: Tab {
    var name = "Podcast"
    let podcasts: [Podcast]

    var content: AnyView {
        AnyView(
            PodcastView(loader: PodcastLoader(podcasts.map { $0.rssUrl }))
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image("Podcast25")
                Text("Podcast")
            }
        )
    }
}
