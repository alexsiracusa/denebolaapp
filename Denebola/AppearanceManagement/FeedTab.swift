//
//  FeedTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct FeedTab: Tab {
    var name = "Feed"
    var id = TabID.feed

    var content: AnyView {
        AnyView(
            CategoriesView()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image("Feed25")
                Text("Feed")
            }
        )
    }
}
