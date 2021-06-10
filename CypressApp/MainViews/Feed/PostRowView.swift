//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostRowView: View {
    @EnvironmentObject var siteImages: SiteImages
    let post: Post

    var body: some View {
        HStack(alignment: .top) {
            if let thumbnailImageURL = post.getThumbnailSizeUrl(size: "medium") {
                ImageView(url: thumbnailImageURL)
                    .scaledToFill()
                    .frame(width: 160, height: 100)
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(5.0)
            } else {
                ImageView(url: siteImages.defaultImageURL)
                    // .resizable()
                    .cornerRadius(5.0)
                    .frame(width: 100, height: 100)
            }
            NavigationLink(destination: PostView(post: post)
                .navigationBarTitle(Text(""), displayMode: .inline)
            ) {
                VStack(alignment: .leading) {
                    // title
                    Text(post.getTitle())
                        .bold()
                        .font(.title3)
                        .lineLimit(nil)
                        .foregroundColor(.black)
                    Text(post.getAuthor())
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(post.getDateRelative())
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }.padding(.vertical, 4.0)

                Spacer()
            }
            Spacer(minLength: 0)
        }
        .frame(height: 100)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: Post.default)
            //.environmentObject(WordpressAPIHandler())
            .environmentObject(SiteImages())
    }
}
