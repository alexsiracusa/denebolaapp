//
//  FeedTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class FeedTab: Tab {
    init(site: Wordpress) {
        self.wordpress = site
    }
    var wordpress: Wordpress
    var tab_icon: AnyView = FeedTab.tab_icon_default
    static var tab_icon_default: AnyView {
        AnyView(
            VStack {
                Image(systemName: "newspaper")
                Text("Feed")
            }
        )
    }
    
    override var tabIcon: AnyView {
        tab_icon
    }
    override var content: AnyView {
        AnyView(
            CategoriesView(wordpress: wordpress)
        )
    }
}

