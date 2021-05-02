//
//  PostFeed.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostFeed: View {
    @EnvironmentObject var handler: APIHandler
    @State var posts: [Post]? = nil
    @State var error: String? = nil
    
    var body: some View {
        if let posts = posts {
            ForEach(posts) { post in
                //let title = post.renderedTitle
                let title = post.title.rendered
                let date = post.date
                let image = post._embedded!.featuredMedia?[0].source_url
                PostRow(title: title, author: "Author", date: date, imageURL: image, post: post)
            }
        } else {
            if let error = error {
                Text(error)
            }
            Text("Loading")
                .onAppear {
                    //The API can't load the media in post 15, id: 25090 because of permissions I think so we need to figure that out
                    handler.loadPostPage(category: nil, page: 1, per_page: 14, embed: true) { posts, error in
                        self.posts = posts
                        self.error = error
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
