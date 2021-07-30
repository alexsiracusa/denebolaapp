//
//  SchoolRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import SwiftUI

struct SchoolRow: View {
    @EnvironmentObject private var viewModel: ViewModelData
    let school: School

    var isCurrentlyLoadingSchool: Bool {
        viewModel.loadingSchool == school.id
    }

    var isLoadedSchool: Bool {
        viewModel.school.id == school.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text(school.name)
                    .padding(.leading)
                    .padding(.vertical, 10)
                Spacer()
                if isCurrentlyLoadingSchool {
                    SpinningLoader()
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                } else if isLoadedSchool {
                    Image(systemName: "checkmark")
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                }
            }
            .frame(height: 45)
            .foregroundColor(.black)
            Divider()
        }
        .frame(height: 45)
    }
}

struct SchoolRow_Previews: PreviewProvider {
    static var previews: some View {
        SchoolRow(school: School.default)
            .environmentObject(ViewModelData.default)
    }
}
