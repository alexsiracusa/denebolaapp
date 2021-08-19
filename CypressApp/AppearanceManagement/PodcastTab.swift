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
    var id = TabID.podcast

    var content: AnyView {
        AnyView(
            PodcastView()
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
