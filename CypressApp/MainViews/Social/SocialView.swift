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

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                SchedulePageView()
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                CancelledList()
                    .padding(.bottom, 20)
            }
        }
        .navigationBarTitle("South", displayMode: .inline)
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
            .environmentObject(ViewModelData.default)
    }
}
