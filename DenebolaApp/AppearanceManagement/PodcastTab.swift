//
//  PodcastTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct PodcastTab: Tab {
    var content: AnyView {
        AnyView(
            PodcastView()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "headphones")
                Text("Podcast")
            }
        )
    }
}
