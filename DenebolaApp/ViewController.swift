//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI
import MediaPlayer

struct ViewController: View {
    @EnvironmentObject var handler: APIHandler
    @State var image: ImageView = ImageView(url: URL(string: "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg")!)
    //@State var playing = true
    @ObservedObject var player: PlayerObject = PlayerObject()
    @State var showingPodcastToolbar = false

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    

    var body: some View {
        TabView {
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
        }
        .background(Color.blue)
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            .environmentObject(APIHandler())
            .environmentObject(PodcastLoader())
    }
}
