//
//  SettingsRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/26/21.
//

import SwiftUI

struct SettingsRow: View {
    let title: String
    let icon: Icon
    let selected: String?
    let withArrow: Bool

    var body: some View {
        HStack {
            icon.view
                .frame(width: 28, height: 28)
                .cornerRadius(5)
            VStack(spacing: 0) {
                HStack {
                    Text(title)
                        .lineLimit(1)
                    Spacer(minLength: 30)
                    if let selected = selected {
                        Text(selected)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    if withArrow {
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                    }
                }
                .padding(.trailing)
                .frame(height: 45)
                Divider()
            }
        }
        .foregroundColor(.black)
        .padding(.leading)
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        let row = SettingsRow(title: "Title", icon: .school, selected: "selected", withArrow: true)
        VStack(spacing: 0) {
            row
            row
            row
            row
        }
    }
}
