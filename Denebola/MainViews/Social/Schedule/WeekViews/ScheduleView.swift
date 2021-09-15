//
//  ScheduleView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/26/21.
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var viewModel: ViewModelData
    @State var week: Week?
    @State var error: String?
    let date: Date
    let height: CGFloat

    @State var showDetail = false
    var showLunches: Bool

    var body: some View {
        if let week = week {
            let times = week.startAndEndTimes()
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 3) {
                    ForEach(Array(zip(week.includedDays.indices, week.includedDays)), id: \.0) { index, day in
                        NavigationLink(destination:
                            DaysPageView(selection: index, days: week.includedDays)
                        ) {
                            ScheduleColumn(blocks: day.blocks, height: height - 20, start: times.start, end: times.end, date: week.startsOn.dateByAdding(day.dayOfWeek.toIndex(), .day).date)
                                .overlay(
                                    VStack {
                                        if showLunches {
                                            Lunches(lunches: day.lunch, height: height - 20, start: times.start, end: times.end)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(ScaleButton(factor: 0.99))
                    }
                }

                HStack {
                    Text(week.week.name)
                        .font(.caption)
                        .bold()
                    Spacer()
                }
                .frame(height: 17)
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 10)
        } else if let error = error {
            Text(error)
        } else {
            LoadingScheduleView(height: height)
                .onAppear {
                    viewModel.school.getWeek(date: date).perform().done { week in
                        self.week = week
                    }.catch { error in
                        self.error = error.localizedDescription
                    }
                }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(date: Date("7/20/2021")!, height: 400, showLunches: false)
            .environmentObject(ViewModelData.default)
    }
}