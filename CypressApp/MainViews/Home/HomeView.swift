//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State private var latestPosts = [Post]()
    @State private var multimediaPosts = [Post]()

    var gradient: some View {
        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: UnitPoint(x: 0.5, y: 0.0), endPoint: .bottom)
            .opacity(0.03)
    }

    func loadPosts() {
        handler.loadPostPage(category: nil, page: 1, per_page: 5, embed: true, completionHandler: { posts, _ in
            guard let posts = posts, posts.count > 0 else { return }
            latestPosts = posts
        })
        handler.loadPostPage(category: 164, page: 1, per_page: 2, embed: true, completionHandler: { posts, _ in
            guard let posts = posts, posts.count > 0 else { return }
            multimediaPosts = posts
        })
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    PostSection(posts: latestPosts)
                        .overlay(gradient)
                    PodcastSection()
                        .overlay(gradient)
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
        HomeView()
            .environmentObject(WordpressAPIHandler())
            .environmentObject(PodcastLoader())
    }
}
