//
//  PropertyEditor.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct PropertyEditor: View {
    var title: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 15) {
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
                .frame(width: 100, alignment: .bottomLeading)
            TextField("-", text: $text)
                .frame(alignment: .bottom)
        }
        .frame(height: 25)
    }
}

struct PropertyEditor_Previews: PreviewProvider {
    static var previews: some View {
        PropertyEditor(title: "TITLE", text: .constant("text"))
    }
}
