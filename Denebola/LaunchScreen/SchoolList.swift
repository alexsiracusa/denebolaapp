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
    @State var listAppeared = false

    var showList: Bool {
        (viewModel.schools != nil && viewModel.loadingSchool == nil) || listAppeared
    }

    var body: some View {
        Group {
            if showList {
                SchoolSelector()
                    .onAppear {
                        listAppeared = true
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
    }
}

struct SchoolList_Previews: PreviewProvider {
    static var previews: some View {
        SchoolList()
            .environmentObject(ViewModelData.default)
    }
}
