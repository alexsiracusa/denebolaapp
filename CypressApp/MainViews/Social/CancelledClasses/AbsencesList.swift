//
//  CancelledList.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/23/21.
//

import LoaderUI
import SwiftUI

struct AbsencesList: View {
    @EnvironmentObject var viewModel: ViewModelData
    var absences: Absences? {
        return viewModel.absences
    }

    @State var error: String?

    func loadAbsences() {
        viewModel.loadAbsences().done { _ in
            error = nil
        }.catch { error in
            self.error = error.localizedDescription
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Text("Absences")
                    .font(.title)
                    .bold()
                if error != nil {
                    Button {
                        self.loadAbsences()
                    } label: {
                        WarningIcon()
                    }
                } else if absences == nil {
                    SpinningLoader()
                        .onAppear {
                            self.loadAbsences()
                        }
                }

                Spacer(minLength: 10)

                if let absences = absences {
                    Text(absences.dateString)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.leading, 5)
                        .offset(y: 3)
                }
            }
            .padding(.horizontal, 15)

            Spacer()
                .frame(height: 5)

            if let absences = absences {
                ForEach(absences.absences) { absence in
                    AbsenceRow(cancelled: absence)
                }

                AbsencesKey()
                    .padding(.vertical, 15)
            }
        }
    }
}

struct CancelledList_Previews: PreviewProvider {
    static var previews: some View {
        AbsencesList()
            .environmentObject(ViewModelData.default)
    }
}
