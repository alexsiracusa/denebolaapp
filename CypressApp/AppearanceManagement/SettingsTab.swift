//
//  SettingsTab.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import Foundation
import SwiftUI

struct SettingsTab: Tab {
    var name = "Settings"
    var id = TabID.settings

    var content: AnyView {
        AnyView(
            SettingsView()
        )
    }

    var tabIcon: AnyView {
        AnyView(
            VStack {
                Image("Settings25")
                Text("Settings")
            }
        )
    }
}
