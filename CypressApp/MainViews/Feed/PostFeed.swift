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

    init(site: Wordpress, category: Int? = nil) {
        self.site = site
        _loader = StateObject(wrappedValue: ScrollViewLoader(site: site, category: category))
    }

    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack(spacing: 10) {
                ForEach(loader.posts) { post in
                    PostRowView(post: post)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: post)
                        }
                        .padding([.leading, .trailing], 15)
                        .padding(.vertical, 0.0)
                }
            }
            .onChange(of: site, perform: { value in
                loader.setSite(value)
            })
            .onAppear {
                loader.resume()
            }
            .onDisappear {
                loader.cancel()
            }
        } else {
            if let error = loader.error {
                VStack {
                    Button {
                        loader.loadMorePosts()
                    } label: {
                        Text("Reload")
                    }
                    Text(error)
                }
            }
            VStack(spacing: 10) {
                ForEach(0 ..< 8) { _ in
                    LoadingPostRowView()
                        .padding([.leading, .trailing], 15)
                }
            }
            .onChange(of: site, perform: { value in
                loader.setSite(value)
            })
            .onDisappear {
                if loader.currentRequest?.retryCount ?? 0 > 0 {
                    loader.cancel()
                }
            }
        }
    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(site: Wordpress.default)
    }
}
