//
//  LongText.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/15/21.
//

import Foundation
import SwiftUI

// stolen from https://stackoverflow.com/questions/59485532/swiftui-how-know-number-of-lines-in-text

struct LongText: View {
    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false

    private var text: String
    private var lineLimit: Int

    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }

    private func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = text.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            truncated = true
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(self.text)
                .font(.system(size: 16))
                .lineLimit(self.expanded ? nil : lineLimit)
                // see https://swiftui-lab.com/geometryreader-to-the-rescue/,
                // and https://swiftui-lab.com/communicating-with-the-view-tree-part-1/
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        self.determineTruncation(geometry)
                    }
                })

            if self.truncated {
                self.toggleButton
            }
        }
    }

    var toggleButton: some View {
        Button {
            withAnimation {
                self.expanded.toggle()
            }
        } label: {
            Text(self.expanded ? "Show less" : "Show more")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LongText_Previews: PreviewProvider {
    static var previews: some View {
        LongText("text very cool very long text text very cool very long text text very cool very long text", lineLimit: 1)
    }
}
