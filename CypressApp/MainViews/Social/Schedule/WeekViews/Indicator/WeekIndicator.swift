//
//  WeekIndicator.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/4/21.
//

import SwiftUI

struct WeekIndicator: View {
    @Binding var selection: Int
    var weeks: [Date]

    func canCenter(_ selection: Int) -> Bool {
        let minIndex = 3
        let maxIndex = weeks.count - 4
        guard minIndex <= maxIndex else { return false }
        return (minIndex ... maxIndex).contains(selection)
    }

    func scrollPoint(_ selection: Int) -> UnitPoint? {
        return canCenter(selection) ? .center : .none
    }

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(zip(weeks.indices, weeks)), id: \.0) { index, week in
                        Button {
                            withAnimation {
                                selection = index
                            }
                        } label: {
                            WeekBlock(date: week, selected: index == selection)
                                .id(index)
                        }
                        .buttonStyle(NoButtonAnimation())
                    }
                }
                .onChange(of: selection) { value in
                    withAnimation {
                        reader.scrollTo(value, anchor: scrollPoint(value))
                    }
                }
            }
            .onAppear {
                reader.scrollTo(selection, anchor: scrollPoint(selection))
            }.introspectScrollView { scrollView in
                scrollView.bounces = false
            }
        }
    }
}

struct WeekIndicator_Previews: PreviewProvider {
    static var previews: some View {
        WeekIndicator(selection: .constant(1), weeks: [Date()])
    }
}
