//
//  LoadingBlockEditor.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/30/21.
//

import SwiftUI

struct LoadingBlockEditor: View {
    let color = Color(UIColor.lightGray)

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
            }
            .frame(height: 30)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(color)

            VStack(alignment: .leading) {
                Row()
                Divider()
                Row()
                Divider()
                Row()
                Divider()
                Row()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(color.opacity(0.3))
        }
    }

    func Row() -> some View {
        HStack(spacing: 15) {
            Text("-")
                .font(.caption)
                .foregroundColor(.black)
                .frame(width: 100, alignment: .bottomLeading)
            Text("-")
                .frame(alignment: .bottom)
        }
        .frame(height: 25)
    }
}

struct LoadingBlockEditor_Previews: PreviewProvider {
    static var previews: some View {
        LoadingBlockEditor()
    }
}
