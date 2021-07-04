//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Alamofire
import Introspect
import MediaPlayer
import SwiftUI

struct ViewController: View {
    @EnvironmentObject var viewModel: ViewModelData
    @EnvironmentObject var player: PlayerObject

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var tabs: [Tab] {
        return viewModel.tabManager!.tabs
    }

    @State var error: String? = nil
    var body: some View {
        Group {
            // has error
            if let error = error {
                Text(error)
            }

            // fully loaded (app view)
            else if viewModel.loaded == .all {
                TabView(selection: $viewModel.selectedTab) {
                    ForEach(0 ..< tabs.count, id: \.self) { n in
                        let tab = tabs[n]

                        NowPlayingBar(content: tab.content)
                            .tag(n)
                            .tabItem {
                                tab.tabIcon
                            }
                            // Handle popping view when tab button clicked again
                            .introspectNavigationController { navigation in
                                ViewManager.shared.addNav(name: tab.name, navController: navigation)
                            }
                            .onReceive(viewModel.$selectedTab) { index in
                                guard index == n else { return }
                                ViewManager.shared.focus(name: tab.name)
                            }
                    }
                }
                .accentColor(.orange)
            }

            // school picker
            else if viewModel.loaded == .list {
                ScrollView {
                    ForEach(viewModel.schools) { school in
                        Button {
                            viewModel.loadSchoolData(school).catch { error in
                                self.error = error.localizedDescription
                            }
                        } label: {
                            Text(school.name)
                        }
                    }
                }
            }

            // fecthing schools
            else if viewModel.loaded == .none {
                VStack {
                    Text("loading")
                }
                .onAppear {
                    viewModel.loadSchoolList().catch { error in
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            // .environmentObject(WordpressAPIHandler())
            .environmentObject(PodcastLoader([]))
            .environmentObject(ViewModelData())
            .environmentObject(PlayerObject())
            .environmentObject(ViewModelData())
    }
}
