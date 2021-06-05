//
//  FeedTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct FeedTab: Tab {
    
    var sites: [Wordpress]
    var content: AnyView {
        AnyView(
            CategoriesView(sites: sites)
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "newspaper")
                Text("Feed")
            }
        )
    }
}
