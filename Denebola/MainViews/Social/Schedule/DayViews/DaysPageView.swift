//
//  DaysPageView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/29/21.
//

import SwiftUI

struct DaysPageView: View {
    @State var selection = 0
    let days: [Day]

    init(selection: Int? = nil, days: [Day]) {
        self.selection = selection ?? 0
        self.days = days
        // UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.black)
        // UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    }

    var navigationTitle: String {
        let dayName = days[selection].name.lowercased()
        let dayOfWeek = days[selection].dayOfWeek.rawValue.lowercased()
        let dayOfWeekShort = days[selection].dayOfWeek.shortName.lowercased()

        if dayName == dayOfWeek || dayName == dayOfWeekShort {
            return dayOfWeek.capitalized
        } else {
            return dayName.capitalized + " (\(dayOfWeekShort.capitalized))"
        }
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(days.enumerated()), id: \.offset) {
                DayDetailView(day: $0.element).tag($0.offset)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationBarTitle(navigationTitle, displayMode: .inline)
    }
}

struct DaysPageView_Previews: PreviewProvider {
    static var previews: some View {
        DaysPageView(days: [Day.default, Day.default, Day.default])
            .environmentObject(ViewModelData.default)
    }
}
