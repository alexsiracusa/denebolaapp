//
//  HomeTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class HomeTab: Tab {
    var tab_icon: AnyView = HomeTab.tab_icon_default
    static var tab_icon_default: AnyView {
        AnyView(
            VStack {
                Image(systemName: "house")
                Text("Home")
            }
        )
    }
    
    override var tabIcon: AnyView {
        tab_icon
    }
    override var content: AnyView {
        AnyView(
            HomeView()
        )
    }
}
