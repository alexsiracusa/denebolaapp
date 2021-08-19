//
//  SmallPostCard.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI

struct PostCard: View {
    let post: Post
    let defaultImageURL: URL

    var body: some View {
        NavigationLink(destination:
            PostView(post: post)
                .navigationBarTitle(Text(""), displayMode: .inline)
        ) {
            VStack(alignment: .leading, spacing: 0) {
                VStack {
                    if let imageURL = post.getFeaturedImageUrl() {
                        ImageView(url: imageURL, aspectRatio: 1.6)
                            .cornerRadius(10)
                    } else {
                        LoadingRectangle()
                            .aspectRatio(1.6, contentMode: .fit)
                            .cornerRadius(10)
                            .overlay(
                                ImageView(url: defaultImageURL, aspectRatio: 1.0)
                                    .cornerRadius(5)
                                    .padding(10),

                                alignment: .center
                            )
                    }
                }
                .frame(width: 220, height: 137.5)

                VStack(alignment: .leading, spacing: 0) {
                    Text(post.getTitle())
                        .bold()
                        .font(.system(size: 13, weight: .regular, design: .default))
                        .padding(.top, 3)
                        .lineLimit(1)
                    Text(post.getDateRelative() + " • " + post.getAuthor())
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(height: 36)
            }
            .foregroundColor(.black)
        }
        .frame(width: 220, height: 163.5)
        .buttonStyle(NoButtonAnimation())
    }
}

struct SmallPostCard_Previews: PreviewProvider {
    static var previews: some View {
        PostCard(post: Post.default, defaultImageURL: URL(string: "https://drive.google.com/uc?id=1VlVnEvr7aBWaxCJKuJt2_IM2Z58c3esH")!)
    }
}
