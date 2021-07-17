//
//  SchedulePageView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/26/21.
//

import PromiseKit
import SwiftUI

class CurrentWeek: ObservableObject {
    @Published var week: Week?
}

struct SchedulePageView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: ViewModelData
    @State var selection = 2
    @State var showLunches = false
    @State var year: SchoolYear?
    var scheduleViews: [ScheduleView]? {
        return year?.weeks.map { ScheduleView(date: $0, height: 400, showLunches: showLunches) }
    }

    let impactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .bottom) {
                    Text("Schedule")
                        .font(.title)
                        .bold()
                        .padding(.horizontal)
                    Spacer()
                    Toggle("", isOn: $showLunches.animation(.easeInOut(duration: 0.3)))
                        .toggleStyle(SwitchToggleStyle())
                        .padding(.horizontal, 10)
                        .frame(width: 80)
                }
            }

            if let year = year {
                WeekIndicator(selection: $selection, weeks: year.weeks, impactStyle: impactStyle)
                    .padding(.vertical, 5)
                    .frame(alignment: .center)

                MultiPageView(pages: scheduleViews!, currentPageIndex: $selection, impactStyle: impactStyle)
                    .frame(height: 400)

            } else {
                LoadingWeekIndicator()
                    .padding(.vertical, 5)
                    .frame(alignment: .center)
                LoadingScheduleView(height: 400)
                    .frame(alignment: .center)
                    .frame(height: 400)
                    .onAppear {
                        viewModel.school.getLatestYear().done { year in
                            self.year = year
                            self.selection = year.weeks.firstIndex(where: {
                                Date().dayInWeek(.monday) == $0
                            }) ?? year.weeks.count - 1
                        }.catch { error in
                            print(error)
                        }
                    }
            }
        }
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
            .environmentObject(ViewModelData.default)
    }
}
