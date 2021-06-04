//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @ObservedObject private var loader: ScrollViewLoader = ScrollViewLoader(domain: "")
    var domain: String

    init(category: Int? = nil, domain: String) {
        self.domain = domain
        loader = ScrollViewLoader(domain: domain, category: category)
    }
    
    init(loader: ScrollViewLoader) {
        self.domain = loader.handler.domain
        self.loader = loader
    }
    

    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack(spacing: 10) {
                ForEach(loader.posts) { post in
                    PostRowView(post: post)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: post)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 0.0)
                }
            }
        } else {
            if let error = loader.error {
                Text(error)
            }
            VStack {
                ForEach(0 ..< 8) { _ in
                    LoadingPostRowView()
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(domain: "https://nshsdenebola.comm")
            .environmentObject(WordpressAPIHandler())
    }
}
