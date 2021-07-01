//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct HomeView: View {
    // @EnvironmentObject private var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State private var latestPosts = [Post]()
    @State private var multimediaPosts = [Post]()

    let sites: [Wordpress]
    let podcasts: [Podcast]

    init(sites: [Wordpress], podcasts: [Podcast]) {
        self.sites = sites
        self.podcasts = podcasts
    }

    var gradient: some View {
        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: .bottom)
            .opacity(0.03)
    }

    func loadPosts() {
        sites[0].getPostPage(category: nil, page: 1, per_page: 5, embed: true) { result in
            switch result {
            case let .success(posts):
                latestPosts = posts
            case .failure:
                _ = 0
            }
        }

        // no more multimedia section since not all websites will have that as a category
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    PostSection(posts: latestPosts)
                        .overlay(gradient)
//                    PodcastSection()
//                        .overlay(gradient)
                    MultimediaSection(posts: multimediaPosts)
                        .overlay(gradient)
                }
                .padding(.top, 10)
            }
            .navigationBarTitle("Home", displayMode: .inline)

        }.onAppear {
            if latestPosts.count == 0 {
                loadPosts()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sites: [Wordpress.default], podcasts: [Podcast.default])
        // .environmentObject(WordpressAPIHandler())
    }
}
