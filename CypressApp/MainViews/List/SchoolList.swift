//
//  SchoolList.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import SwiftUI

struct SchoolList: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @State var error: String? = nil

    var title: String {
        viewModel.loadingSchool == nil ? "Selected a School" : "Loading"
    }

    var body: some View {
        Group {
            if let schools = viewModel.schools {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(schools) { school in
                            Button {
                                viewModel.loadSchoolData(school).catch { error in
                                    self.error = error.localizedDescription
                                }
                            } label: {
                                SchoolRow(school: school)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    SpinningLoader()
                    Spacer()
                }
                .onAppear {
                    viewModel.selectSchool().catch { error in
                        self.error = error.localizedDescription
                    }
                }
            }
        }
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct SchoolList_Previews: PreviewProvider {
    static var previews: some View {
        SchoolList()
            .environmentObject(ViewModelData.default)
    }
}
