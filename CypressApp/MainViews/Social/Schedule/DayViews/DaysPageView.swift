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

    var dayName: String {
        return days[selection].name
    }

    var dayOfWeek: String {
        return days[selection].dayOfWeek
    }

    var body: some View {
        let views = days.map { DayDetailView(day: $0) }
        MultiPageView(pages: views, currentPageIndex: $selection, offset: 10)
            .navigationBarTitle("\(dayName)\(dayName == dayOfWeek ? "" : " (\(dayOfWeek))")", displayMode: .inline)
    }
}

struct DaysPageView_Previews: PreviewProvider {
    static var previews: some View {
        DaysPageView(days: [Day.default, Day.default, Day.default])
            .environmentObject(ViewModelData.default)
    }
}
