//
//  SettingsView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/26/21.
//

import Disk
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: ViewModelData

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SettingsRowNav(
                    title: "Current School",
                    icon: .school,
                    destination: AnyView(SchoolSelector()),
                    selected: viewModel.school?.name
                )
                SettingsRowAlert(
                    title: "Clear Cache",
                    icon: .cache,
                    selected: nil,
                    alert: Alert(
                        title: Text("Clear Cache"),
                        message: Text("are you sure you want to clear the cache?"),
                        primaryButton: .destructive(Text("Clear")) {
                            try? Disk.clear(.caches)
                            URLCache.shared.removeAllCachedResponses()
                        },
                        secondaryButton: .default(Text("Cancel"))
                    )
                )
            }
            .padding(.top, 10)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModelData.default)
    }
}
