//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct ViewController: View {
    @EnvironmentObject var handler: APIHandler
    @EnvironmentObject var viewModel: ViewModelData

    @EnvironmentObject var player: PlayerObject
    var showingPodcastToolbar: Bool {
        return player.showingToolbar
    }

    var image: ImageView {
        return player.image
    }

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        //setting up tab styles
        self.tabManager = TabManager()
        tabManager.categoriesStyle = .image
    }
    
    @State var tabManager: TabManager
    var tabs : [Tab] {
        return tabManager.tabs
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(0..<tabs.count, id: \.self) { n in
                let tab = tabs[n]
                tab.content
                    .tabItem {
                        tab.tabIcon
                    }
            }
            SettingsView(manager: tabManager)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(20)
        }
        .accentColor(.orange)
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            .environmentObject(APIHandler())
            .environmentObject(PodcastLoader())
            .environmentObject(ViewModelData())
            .environmentObject(PlayerObject())
    }
}
