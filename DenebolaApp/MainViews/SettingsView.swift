//
//  SettingsView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: TabManager
    var body: some View {
        NavigationView {
            Form {
                
                Picker(selection: $manager.categoriesStyle, label: Text("Categories Style")) {
                    ForEach(CategoriesStyle.allCases, id: \.self) {
                        Text("\($0.rawValue)").tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationBarHidden(true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(manager: TabManager())
    }
}
