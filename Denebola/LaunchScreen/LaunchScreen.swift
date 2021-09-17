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
    @State var error: Error? = nil

    func load() {
        viewModel.selectSchool().done {
            if viewModel.school != nil {
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
        .catch { error in
            self.error = error
        }
    }

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
                GeometryReader { geo in
                    Image("DenebolaLogoNoBackground")
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .zIndex(1)

                    Color.white.ignoresSafeArea()
                        .zIndex(0)

                    Group {
                        if error != nil {
                            Button {
                                self.error = nil
                                load()
                            } label: {
                                Image("reload")
                                    .resizable()
                                    .frame(width: 27, height: 27)
                            }
                        } else {
                            SpinningLoader()
                                .scaleEffect(1.33)
                        }
                    }
                    .frame(width: 30, height: 30)
                    .position(x: geo.size.width / 2, y: geo.size.height / 1.5)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            load()
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
