//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @StateObject private var loader = ScrollViewLoader(domain: "")
    var domain: String

    init(category: Int? = nil, domain: String) {
        self.domain = domain
        _loader = StateObject(wrappedValue: ScrollViewLoader(domain: domain, category: category))
    }

    init(loader: ScrollViewLoader) {
        self.domain = loader.handler.domain
        _loader = StateObject(wrappedValue: loader)
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
            .onChange(of: domain, perform: { value in
                loader.setDomain(value)
            })
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
            VStack {
                ForEach(0 ..< 8) { _ in
                    LoadingPostRowView()
                        .padding(.top, 5)
                }
            }
            .onChange(of: domain, perform: { value in
                loader.setDomain(value)
            })
        }
    }
}

struct PostFeed_Previews: PreviewProvider {
    static var previews: some View {
        PostFeed(domain: "https://nshsdenebola.com")
    }
}
