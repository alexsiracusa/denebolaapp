//
//  SchoolSelector.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/26/21.
//

import SwiftUI

struct SchoolSelector: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @Environment(\.presentationMode) var presentationMode

    @State var failedToLoad = false
    @State var retrySchool: School? = nil

    var body: some View {
        ScrollView {
            if let schools = viewModel.schools {
                VStack(spacing: 0) {
                    ForEach(schools.sorted(by: { $0.name < $1.name })) { school in
                        Button {
                            loadSchool(school: school)
                        } label: {
                            SchoolRow(school: school)
                        }
                        .disabled(viewModel.loadingSchool != nil)
                        .buttonStyle(OpacityButton())
                    }
                }
                .padding(.top, 10)
            } else {
                if let school = viewModel.school {
                    Button {
                        loadSchool(school: school)
                    } label: {
                        SchoolRow(school: school)
                    }
                    .padding(.top, 10)
                } else {
                    Text("Loading")
                }
            }
        }
        .onAppear {
            if viewModel.schools == nil {
                viewModel.loadSchoolList().done {}.catch { _ in }
            }
        }
        .alert(isPresented: $failedToLoad) {
            Alert(title: Text("School has failed to load"), message: nil, dismissButton: .default(Text("Ok")))
        }
        .navigationBarTitle("Schools", displayMode: .inline)
    }

    func loadSchool(school: School) {
        let useCache = school.id != viewModel.school?.id ?? -1
        retrySchool = school
        let old = viewModel.school
        viewModel.school = school
        viewModel.loadSchoolData(school, useCache: useCache, retry: false).done {
            presentationMode.wrappedValue.dismiss()
        }.catch { _ in
            viewModel.school = old
            failedToLoad = true
        }
    }
}

struct SchoolSelector_Previews: PreviewProvider {
    static var previews: some View {
        SchoolSelector()
            .environmentObject(ViewModelData.default)
    }
}
