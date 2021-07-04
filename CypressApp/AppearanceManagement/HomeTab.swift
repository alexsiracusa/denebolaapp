//
//  HomeTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct HomeTab: Tab {
    let sites: [Wordpress]
    let podcasts: [Podcast]

    var name = "Home"

    var content: AnyView {
        AnyView(HomeView(sites: sites, podcasts: podcasts))
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "house")
                Text("Home")
            }
        )
    }
}
