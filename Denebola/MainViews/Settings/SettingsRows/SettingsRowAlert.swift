//
//  SettingsRowAlert.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import SwiftUI

struct SettingsRowAlert: View {
    let title: String
    let icon: Icon
    let selected: String?
    let alert: Alert

    @State var showAlert = false

    var body: some View {
        Button {
            showAlert = true
        } label: {
            SettingsRow(title: title, icon: icon, selected: selected, withArrow: false)
        }
        .buttonStyle(OpacityButton())
        .alert(isPresented: $showAlert, content: {
            alert
        })
    }
}

struct SettingsRowAlert_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowAlert(
            title: "Title",
            icon: .school,
            selected: "selected",
            alert: Alert(
                title: Text("Alert"),
                message: nil,
                primaryButton: .destructive(Text("delete")),
                secondaryButton: .destructive(Text("ok"))
            )
        )
    }
}
