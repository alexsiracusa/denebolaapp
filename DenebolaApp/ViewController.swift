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

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    //@State var player = AVPlayer()

    var body: some View {
        TabView {
            GeometryReader { geometry in
                HomeView()
                PodcastToolbar(image: image, player: player)
                    .frame(width: geometry.size.width, height: 70)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 35)
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            MultimediaView()
                .tabItem {
                    Image(systemName: "video")
                    Text("Multimedia")
                }
            CategoriesView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Feed")
                }
            PodcastView(player: player)
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
