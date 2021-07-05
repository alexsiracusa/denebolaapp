//
//  CancelledList.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/23/21.
//

import LoaderUI
import SwiftUI

struct CancelledList: View {
    @EnvironmentObject var viewModel: ViewModelData
    @State var absences: Absences?
    @State var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 10) {
                Text("Cancelled Classes")
                    .font(.title)
                    .bold()
                if let absences = absences {
                    Spacer()
                    Text(absences.dateString)
                        .font(.caption)
                        .bold()
                } else {
                    SpinningLoader()
                    Spacer()
                }
            }

            if let absences = absences {
                ForEach(absences.absences) { absence in
                    CancelledRow(cancelled: absence)
                    Divider()
                }
            } else if let error = error {
                Text(error)
            } else {
                Spacer()
                    .padding(.horizontal, 10)
                    .onAppear {
                        // TODO: change this
                        viewModel.school.getLatestAbsences().done { absences in
                            self.absences = absences
                        }.catch { error in
                            self.error = error.localizedDescription
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct CancelledList_Previews: PreviewProvider {
    static var previews: some View {
        CancelledList()
            .environmentObject(ViewModelData.default)
    }
}
