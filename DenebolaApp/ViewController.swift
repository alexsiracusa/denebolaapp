//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct ViewController: View {
    @EnvironmentObject var handler: APIHandler
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            HomeView()
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
            PodcastView()
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
    }
}
