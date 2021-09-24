//
//  SocialView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/25/21.
//

import SwiftDate
import SwiftUI

struct SocialView: View {
    @EnvironmentObject var viewModel: ViewModelData

    @State var showingScheduleDay: Int = 0
    @State var showingSchedule: Bool = false

    func onRefresh(_ doneRefresh: @escaping () -> Void) {
        viewModel.loadAbsences()
            .refreshTimeout()
            .then { _ in viewModel.loadSchoolYear() }
            .catch(viewModel.handleError(context: "Refresh failed."))
            .finally { doneRefresh() }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                SchedulePageView()
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                AbsencesList()
                    .padding(.bottom, 20)
            }
        }
        .navigationBarTitle("Social", displayMode: .inline)
        .pullToRefresh(viewModel.getRefreshModifier(for: "social", callback: onRefresh))
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
            .environmentObject(ViewModelData.default)
    }
}
