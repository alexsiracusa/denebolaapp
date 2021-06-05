//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct ViewController: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject var viewModel: ViewModelData
    @EnvironmentObject var player: PlayerObject
    
    @State var loaded = false
    @EnvironmentObject var serverLoader: ServerAPIHandler
    @EnvironmentObject var defaultImage: SiteImages
    @State var school: School? = nil

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        //setting up tab styles
    }
    
    @State var tabManager: TabManager? = nil
    var tabs : [Tab] {
        return tabManager!.tabs
    }

    @State var error: String? = nil
    var body: some View {
        if loaded {
            TabView(selection: $viewModel.selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { n in
                    let tab = tabs[n]
                    tab.content
                        .tabItem {
                            tab.tabIcon
                        }
                }
            }
            .accentColor(.orange)
        } else {
            VStack {
                if let error = error {
                    Text(error)
                }
                Text("loading")
            }
            .onAppear {
                loadTabs()
            }
        }
    }
    
    func loadTabs() {
        serverLoader.loadSchool(0) { school, error in
            self.school = school
            self.error = error
            guard let school = school else {return}
            self.tabManager = TabManager(school.allTabs())
            
            if error == nil {loaded = true}
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            .environmentObject(WordpressAPIHandler())
            .environmentObject(PodcastLoader())
            .environmentObject(ViewModelData())
            .environmentObject(PlayerObject())
            .environmentObject(ServerAPIHandler())
            .environmentObject(SiteImages())
    }
}
