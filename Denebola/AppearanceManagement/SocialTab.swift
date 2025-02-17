//
//  ScheduleTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct SocialTab: Tab {
    var name = "Schedule"
    var id = TabID.social

    var content: AnyView {
        AnyView(
            SocialView()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image("Social25")
                Text("Social")
            }
        )
    }
}
