//
//  SchoolListTab.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import Foundation
import SwiftUI

struct SchoolListTab: Tab {
    var name = "SchoolList"

    var content: AnyView {
        AnyView(
            SchoolList()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image("School25")
                Text("Schools")
            }
        )
    }
}
