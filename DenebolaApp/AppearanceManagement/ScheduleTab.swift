//
//  ScheduleTab.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import Foundation
import SwiftUI

class ScheduleTab: Tab {
    var tab_icon: AnyView = ScheduleTab.tab_icon_default
    static var tab_icon_default: AnyView {
        AnyView(
            VStack {
                Image(systemName: "person")
                Text("South")
            }
        )
    }
    
    override var tabIcon: AnyView {
        tab_icon
    }
    override var content: AnyView {
        AnyView(
            SocialView()
        )
    }
}
