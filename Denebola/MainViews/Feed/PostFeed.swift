//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @StateObject private var loader: ScrollViewLoader
    let site: Wordpress

    init(site: Wordpress, category: SimpleCategory? = nil) {
        self.site = site
        _loader = StateObject(wrappedValue: ScrollViewLoader(site: site, category: category))
    }

    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack(spacing: 0) {
                ForEach(loader.posts) { post in
                    PostRowView(post: post)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: post)
                        }
                }
            }
            .onChange(of: site, perform: { value in
                loader.setSite(value)
            })
        } else {
            if let error = loader.error {
                VStack(spacing: 10) {
                    Button {
                        loader.loadMorePosts()
                    } label: {
                        Text("Reload")
                    }
                    Text(error)
                }
            }
            VStack(spacing: 0) {
                ForEach(0 ..< 8) { _ in
                    LoadingPostRowView()
                }
            }
            .onChange(of: site, perform: { value in
                loader.setSite(value)
            })
        }
    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(site: Wordpress.default)
    }
}
