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

    @ObservedObject var player = PlayerObject()
    @State var showingPodcastToolbar = false
    
    var image: ImageView {
        return player.image
    }

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            GeometryReader { geometry in
                HomeView()
                if showingPodcastToolbar {
                    PodcastToolbar(image: image, player: player, showingPodcastToolbar: $showingPodcastToolbar)
                        .frame(width: geometry.size.width, height: 50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 25)
                        .transition(.move(edge: .bottom))
                }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(1)

            GeometryReader { geometry in
                MultimediaView()
                if showingPodcastToolbar {
                    PodcastToolbar(image: image, player: player, showingPodcastToolbar: $showingPodcastToolbar)
                        .frame(width: geometry.size.width, height: 50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 25)
                }
            }
            .tabItem {
                Image(systemName: "video")
                Text("Multimedia")
            }
            .tag(2)

            GeometryReader { geometry in
                CategoriesView()
                if showingPodcastToolbar {
                    PodcastToolbar(image: image, player: player, showingPodcastToolbar: $showingPodcastToolbar)
                        .frame(width: geometry.size.width, height: 50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 25)
                }
            }
            .tabItem {
                Image(systemName: "newspaper")
                Text("Feed")
            }
            .tag(3)

            GeometryReader { geometry in
                PodcastView(player: player, showingToolbar: $showingPodcastToolbar)
                if showingPodcastToolbar {
                    PodcastToolbar(image: image, player: player, showingPodcastToolbar: $showingPodcastToolbar)
                        .frame(width: geometry.size.width, height: 50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 25)
                        .transition(.move(edge: .bottom))
                }
            }
            .tabItem {
                Image(systemName: "headphones")
                Text("Podcast")
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
    }
}
