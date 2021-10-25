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
    // Used to keep track of whether the currentWeekIndex was scrolled to already
    @State var loadedYear = Int.min

    var year: SchoolYear? {
        return viewModel.year
    }

    private func updateYear() {
        if let year = year, loadedYear != year.id {
            selection = year.currentWeekIndex
            loadedYear = year.id
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center) {
                    Text("Schedule")
                        .font(.title)
                        .bold()
                        .padding(.leading)
                    EditButton()
                    Spacer()
                    Toggle("", isOn: $showLunches.animation(.easeInOut(duration: 0.3)))
                        .toggleStyle(SwitchToggleStyle())
                        .padding(.horizontal, 10)
                        .frame(width: 80)
                }
            }
            // In case of an update
            .onChange(of: viewModel.year) { _ in
                self.updateYear()
            }

            if let year = year {
                WeekIndicator(selection: $selection, weeks: year.weeks)
                    .padding(.vertical, 5)
                    .frame(alignment: .center)

                TabView(selection: $selection) {
                    ForEach(Array(year.weeks.enumerated()), id: \.offset) {
                        ScheduleView(date: $0.element, height: 400, showLunches: showLunches, selection: $selection, id: $0.offset)
                            .tag($0.offset)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)

            } else {
                LoadingWeekIndicator()
                    .padding(.vertical, 5)
                    .frame(alignment: .center)
                LoadingScheduleView(height: 400)
                    .frame(alignment: .center)
                    .frame(height: 400)
                    .onAppear {
                        viewModel.loadSchoolYear().done {
                            self.selection = viewModel.year!.currentWeekIndex
                        }.catch { error in
                            print(error)
                        }
                    }
            }
        }
    }

    func EditButton() -> some View {
        NavigationLink(destination:
            ScheduleSettings()
        ) {
            Image(systemName: "square.and.pencil")
        }
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
            .environmentObject(ViewModelData.default)
    }
}
