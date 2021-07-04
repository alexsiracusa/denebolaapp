//
//  ScheduleTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

struct ScheduleTab: Tab {
    var name = "Schedule"

    var content: AnyView {
        AnyView(
            SocialView()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "person")
                Text("South")
            }
        )
    }
}
