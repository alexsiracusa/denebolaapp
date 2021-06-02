//
//  PodcastTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class PodcastTab: Tab {
    override var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "headphones")
                Text("Podcast")
            }
        )
    }
    override var content: AnyView {
        AnyView(
            PodcastView()
        )
    }
}
