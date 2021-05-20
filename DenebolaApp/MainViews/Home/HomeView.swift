//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var handler: APIHandler

    @State private var latestPosts = [PostRow]()
    @State private var multimediaPosts = [PostRow]()

    func loadPosts() {
        handler.loadPostPage(category: nil, page: 1, per_page: 5, embed: true, completionHandler: { posts, _ in
            guard let posts = posts, posts.count > 0 else { return }
            latestPosts = posts.map { $0.asPostRow(thumbnailSize: "large") }
        })
        handler.loadPostPage(category: Categories.multimedia.id, page: 1, per_page: 2, embed: true, completionHandler: { posts, _ in
            guard let posts = posts, posts.count > 0 else { return }
            multimediaPosts = posts.map { $0.asPostRow(thumbnailSize: "large") }
        })
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    PostSection(posts: latestPosts)
                    PodcastSection()
                    MultimediaSection(posts: multimediaPosts)
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: ToolbarLogo())
            .padding(.vertical, 10)
            .padding(.horizontal, 20)

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
            .environmentObject(APIHandler())
            .environmentObject(PodcastLoader())
    }
}
