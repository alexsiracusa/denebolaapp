//
//  FeedTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class FeedTab: Tab {
    override var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "newspaper")
                Text("Feed")
            }
        )
    }
    override var content: AnyView {
        AnyView(
            CategoriesView()
        )
    }
}
