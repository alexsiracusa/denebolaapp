//
//  PostCard.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/19/21.
//

import LoaderUI
import SwiftUI

struct PostCard: View {
    let post: Post
    let textSize: Font

    var body: some View {
        NavigationLink(destination:
            PostView(post: post)
                .navigationBarTitle(Text(""), displayMode: .inline)
        ) {
            VStack(alignment: .leading) {
                if let imageURL = post.getFeaturedImageUrl() {
                    ImageView(url: imageURL, aspectRatio: 1.6)
                        .cornerRadius(5)
                } else {
                    // TODO:
                }

                Text(post.getTitle())
                    .bold()
                    .font(textSize)
                Text(post.getAuthor())
                Text(post.getDateRelative())
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.black)
        }
        .buttonStyle(NoButtonAnimation())
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        PostCard(post: Post.default, textSize: .subheadline)
        // .environmentObject(WordpressAPIHandler())
    }
}
