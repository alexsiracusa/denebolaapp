//
//  ScheduleTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class ScheduleTab: Tab {
    override var tabIcon: AnyView {
        AnyView(
            VStack {
                Image(systemName: "person")
                Text("South")
            }
        )
    }
    override var content: AnyView {
        AnyView(
            SocialView()
        )
    }
}
