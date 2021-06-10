//
//  ViewController.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI
import Alamofire

struct ViewController: View {
    //@EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject var viewModel: ViewModelData
    @EnvironmentObject var player: PlayerObject

    @EnvironmentObject var siteImages: SiteImages
    @State var schools: [School]? = nil
    @State var school: SchoolConfig? = nil
    @State var request: Request? = nil

    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    @State var tabManager: TabManager? = nil
    var tabs: [Tab] {
        return tabManager!.tabs
    }

    @State var error: String? = nil
    var body: some View {
        if school != nil {
            TabView(selection: $viewModel.selectedTab) {
                ForEach(0 ..< tabs.count, id: \.self) { n in
                    let tab = tabs[n]
                    tab.content
                        .tabItem {
                            tab.tabIcon
                        }
                }
            }
            .accentColor(.orange)
        } else if let schools = schools {
            ScrollView {
                ForEach(schools) { school in
                    Button {
                        guard request == nil else {return}
                        self.request = school.getConfig { result in
                            switch result {
                            case .success(let config):
                                self.tabManager = TabManager(config.allTabs())
                                self.school = config
                                self.request = nil
                            case .failure(let error):
                                self.error = error.errorDescription
                                AF.retryRequest(request!, withDelay: 10)
                            }
                        }
                    } label: {
                        Text(school.name)
                    }
                }
            }
        } else if schools == nil {
            VStack {
                if let error = error {
                    Text(error)
                }
                Text("loading")
            }
            .onAppear {
                loadSchools()
            }
        }
    }
    
    func loadSchools() {
        guard request == nil else {return}
        self.request = ServerAPI.getSchools() { result in
            switch result {
            case .success(let schools):
                self.schools = schools
                self.request = nil
            case .failure(let error):
                self.error = error.errorDescription
                AF.retryRequest(request!, withDelay: 3)
                AF.retryRequest(request!, withDelay: 3)
            }
        }
    }
    
//    func schoolCompletion(_ result: Result<[School], AFError>) -> Void {
//        switch result {
//        case .success(let schools):
//            self.schools = schools
//            self.request = nil
//        case .failure(let error):
//            self.error = error.errorDescription
//            AF.retryRequest(request!, withDelay: 3)
//            AF.retryResult(for: request!, dueTo: error) { res}
//        }
//    }
    
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
            //.environmentObject(WordpressAPIHandler())
            .environmentObject(PodcastLoader())
            .environmentObject(ViewModelData())
            .environmentObject(PlayerObject())
            .environmentObject(SiteImages())
    }
}
