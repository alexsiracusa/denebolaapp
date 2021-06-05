//
//  HomeTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct HomeTab: Tab {
    var content: AnyView {
        AnyView(HomeView())
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
