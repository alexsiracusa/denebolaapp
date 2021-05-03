//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @EnvironmentObject var handler: APIHandler
    @ObservedObject var loader = ScrollViewLoader(category: nil)
    
    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack {
                ForEach(loader.posts) { postRow in
                    PostRowView(postRow: postRow)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: postRow)
                        }
                }
            }
        } else {
            if let error = loader.error {
                Text(error)
            }
            VStack {
                ForEach(0..<8) { n in
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
