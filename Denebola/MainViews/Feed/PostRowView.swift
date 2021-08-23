//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct PostRowView: View {
    @EnvironmentObject var viewModel: ViewModelData
    let post: Post

    var body: some View {
        NavigationLink(destination: PostView(post: post)
            .navigationBarTitle(Text(""), displayMode: .inline)
        ) {
            HStack(alignment: .top) {
                if let thumbnailImageURL = post.getThumbnailSizeUrl(size: "medium") {
                    ImageView(url: thumbnailImageURL, shouldReset: true, aspectRatio: 1.6)
                        .frame(height: 90)
                        .cornerRadius(10.0)
                } else {
                    ImageView(url: viewModel.currentSite.defaultImageURL, aspectRatio: 1.0)
                        .cornerRadius(10.0)
                        .frame(width: 90, height: 90)
                }

                VStack(alignment: .leading) {
                    // title
                    Text(post.getTitle())
                        .bold()
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.black)
                    Text(post.getAuthor())
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.black)
                    Text(post.getDateRelative())
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .font(.subheadline)
                }
                .padding(.vertical, 4.0)

                Spacer(minLength: 0)
            }
            .frame(height: 90)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
        }
        .buttonStyle(OpacityButton())
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: Post.default)
            .environmentObject(ViewModelData.default)
    }
}
