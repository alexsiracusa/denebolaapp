//
//  CancelledRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/23/21.
//

import SwiftUI

struct AbsenceRow: View {
    @State private var showingMore = false
    let cancelled: Absence

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    showingMore.toggle()
                }
            } label: {
                HStack(alignment: .top, spacing: 0) {
                    Dot(color: cancelled.hasRemarks() ? .yellow : .red)
                        .padding(12)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            Text(cancelled.lastName.uppercased())
                                .frame(width: 160, alignment: .leading)
                            Text(cancelled.firstName.uppercased())
                                .frame(alignment: .leading)

                            Spacer()

                            if cancelled.hasRemarks() {
                                Image(systemName: "chevron.right")
                                    .rotationEffect(showingMore ? .degrees(90) : .degrees(0))
                                    .padding(.trailing, 15)
                            }
                        }
                        .frame(height: 35)
                    }
                }
                .zIndex(1)
            }
            .disabled(!cancelled.hasRemarks())
            .buttonStyle(OpacityButton())

            VStack {
                if showingMore {
                    Text(cancelled.remarks)
                        .foregroundColor(.secondary)
                        .transition(.move(edge: .top))
                        .padding(.bottom, 8)
                        .padding(.trailing, 15)
                        .padding(.leading, 34)
                        .zIndex(0)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                showingMore = false
                            }
                        }
                }
            }
            .frame(height: showingMore ? nil : 0)
            .clipped()

            Divider()
                .padding(.leading, 34)
                .zIndex(2)
        }
        .clipped()
    }
}

struct CancelledRow_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceRow(cancelled: Absence.default)
    }
}
