//
//  SchedulePageView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/26/21.
//

import SwiftUI

class CurrentWeek: ObservableObject {
    @Published var week: Week?
}

struct SchedulePageView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: ViewModelData
    @State var selection = 1
    @State var showLunches = false

    var pages: [ScheduleView] {
        // TODO: update weeks to be the current ones when the API is finished
        let lastWeek = ScheduleView(date: Date("6/22/2021")!, height: 400, showLunches: showLunches)
        let thisWeek = ScheduleView(date: Date("6/22/2021")!, height: 400, showLunches: showLunches)
        let nextWeek = ScheduleView(date: Date("6/22/2021")!, height: 400, showLunches: showLunches)
        return [lastWeek, thisWeek, nextWeek]
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Schedule")
                .font(.title)
                .bold()
                .padding(.horizontal)
            Toggle("", isOn: $showLunches.animation(.easeInOut(duration: 0.3)))
                .toggleStyle(SwitchToggleStyle())
                .padding(.horizontal, 10)

            MultiPageView(pages: pages, currentPageIndex: $selection, offset: -30)
                .frame(height: 400)
        }
        .onAppear {
            if let school = moc.getSchoolWith(id: Int64(viewModel.school.id)) {
                moc.updateSchool(school: school, blocks: viewModel.blocks)
            } else {
                moc.createSchool(school: viewModel.school, blocks: viewModel.blocks)
            }
        }
    }
}

struct SchedulePageView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePageView()
            .environmentObject(ViewModelData.default)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
