//
//  LaunchScreen.swift
//  Denebola
//
//  Created by Alex Siracusa on 9/9/21.
//

import SwiftUI

struct LaunchScreen: View {
    @EnvironmentObject var viewModel: ViewModelData
    @State var showList = false

    var body: some View {
        Group {
            if showList {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Select a School")
                            .font(.title)
                            .bold()
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer(minLength: 0)
                    }

                    SchoolList()
                }
            } else {
                ZStack(alignment: .center) {
                    Image("DenebolaLogoNoBackground")
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .zIndex(1)

                    Color.white.ignoresSafeArea()
                        .zIndex(0)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.selectSchool().done {
                if let _ = viewModel.school {
                    viewModel.launching = false
                } else {
                    if viewModel.schools == nil {
                        viewModel.loadSchoolList().done { _ in
                            showList = true
                        }
                    } else {
                        showList = true
                    }
                }
            }
            .catch { _ in
                // do something idk
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .environmentObject(ViewModelData.default)
            .environmentObject(PlayerObject.default)
    }
}
