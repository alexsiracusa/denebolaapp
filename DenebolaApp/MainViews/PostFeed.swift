//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @EnvironmentObject var handler: APIHandler
    @StateObject private var loader: ScrollViewLoader

    init(category: Int? = nil) {
        _loader = StateObject(wrappedValue: ScrollViewLoader(category: category))
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
        PostFeed()
            .environmentObject(APIHandler())
    }
}
