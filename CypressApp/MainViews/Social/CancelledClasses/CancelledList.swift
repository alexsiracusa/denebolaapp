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
    @State var absences: [Absence]?
    @State var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 10) {
                Text("Cancelled Classes")
                    .font(.title)
                    .bold()
                if absences == nil {
                    SpinningLoader()
                }
                Spacer()
            }

            if let absences = absences {
                ForEach(absences) { absence in
                    CancelledRow(cancelled: absence)
                    Divider()
                }
            } else if let error = error {
                Text(error)
            } else {
                Spacer()
                    .padding(.horizontal, 10)
                    .onAppear {
                        viewModel.school.absences { result in
                            switch result {
                            case let .success(absences):
                                self.absences = absences
                            case let .failure(error):
                                self.error = error.errorDescription
                            }
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
