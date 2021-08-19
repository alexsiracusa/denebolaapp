//
//  SettingsRowNav.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import SwiftUI

struct SettingsRowNav: View {
    let title: String
    let icon: Icon
    let destination: AnyView
    let selected: String?

    var body: some View {
        NavigationLink(destination:
            destination
        ) {
            SettingsRow(title: title, icon: icon, selected: selected, withArrow: true)
        }
        .buttonStyle(OpacityButton())
    }
}

struct SettingsRowNav_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowNav(title: "Title", icon: .school, destination: AnyView(Text("Destination")), selected: "selected")
    }
}
