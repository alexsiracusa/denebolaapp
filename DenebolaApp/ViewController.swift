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
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)

            CategoriesView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Feed")
                }
                .tag(2)

            PodcastView()
                .environmentObject(player)
                .tabItem {
                    Image(systemName: "headphones")
                    Text("Podcast")
                }
                .tag(3)

            SocialView()
                .tabItem {
                    Image(systemName: "person")
                    Text("South")
                }
                .tag(4)
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
