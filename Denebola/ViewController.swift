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

    @Namespace var ns

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
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                if viewModel.loaded == .all {
                    ForEach(0 ..< tabs.count, id: \.self) { n in
                        let tab = tabs[n]

                        Tab(tab, tag: tab.id.rawValue)
                    }
                } else {
                    Tab(SchoolListTab(), tag: TabID.list.rawValue)
                }

                Tab(SettingsTab(), tag: TabID.settings.rawValue)
            }
            MiniPlayer(animation: ns, expand: $viewModel.podcastExpanded)
        }
        .ignoresSafeArea(.keyboard)
        .accentColor(.orange)
    }

    func Tab(_ tab: Tab, tag: Int) -> some View {
        NavigationView {
            tab.content
        }
        .tabItem {
            tab.tabIcon
        }
        .tag(tag)
        .introspectNavigationController { navigation in
            ViewManager.shared.addNav(name: tab.name, navController: navigation)
        }
        .onReceive(viewModel.$selectedTab) { index in
            guard index == tag else { return }
            ViewManager.shared.focus(name: tab.name)
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            .environmentObject(ViewModelData.default)
            .environmentObject(PlayerObject.default)
    }
}
