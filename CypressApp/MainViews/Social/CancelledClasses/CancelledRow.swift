//
//  CancelledRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/23/21.
//

import SwiftUI

struct CancelledRow: View {
    @State private var showingMore = false
    let cancelled: Absence

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center) {
                Circle()
                    .foregroundColor(cancelled.hasRemarks() ? .yellow : .red)
                    .frame(width: 10, height: 10)

                Text(cancelled.lastName.uppercased())
                    .frame(width: 160, alignment: .leading)
                Text(cancelled.firstName.uppercased())
                    .frame(alignment: .leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .rotationEffect(showingMore ? .degrees(90) : .degrees(0))
            }
            .background(Color.white)
            .zIndex(1)
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.2)) {
                    showingMore.toggle()
                }
            }

            if showingMore {
                if cancelled.hasRemarks() {
                    Text(cancelled.remarks)
                        .foregroundColor(.secondary)
                        .transition(.move(edge: .top))
                        .zIndex(0)
                } else {
                    Text("All Blocks Cancelled")
                        .foregroundColor(.secondary)
                        .transition(.move(edge: .top))
                        .zIndex(0)
                }
            }
        }
        .clipped()
    }
}

struct CancelledRow_Previews: PreviewProvider {
    static var previews: some View {
        CancelledRow(cancelled: Absence.default)
    }
}
