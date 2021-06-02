//
//  HomeTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class HomeTab: Tab {
    override var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "house")
                Text("Home")
            }
        )
    }
    override var content: AnyView {
        AnyView(
            HomeView()
        )
    }
}
