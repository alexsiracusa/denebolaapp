//
//  FeedTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class FeedTab: Tab {
    var feedStyle = FeedStyle.normal
    var categoriesStyle = CategoriesStyle.image
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
            CategoriesView(style: feedStyle)
        )
    }
}

enum FeedStyle {
    case floating
    case normal
}

enum CategoriesStyle {
    case image
    case box
}
