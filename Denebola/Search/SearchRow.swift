//
//  SearchRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchRow: View {
    @EnvironmentObject private var viewModel: ViewModelData
    let post: Post

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination:
                PostView(post: post)
                    .navigationBarTitle(Text(""), displayMode: .inline)
            ) {
                HStack(alignment: .center) {
                    if let thumbnailImageURL = post.getThumbnailSizeUrl(size: "medium") {
                        ImageView(url: thumbnailImageURL)
                            .scaledToFill()
                            .frame(width: 136, height: 85)
                            .clipped()
                            .aspectRatio(1.6, contentMode: .fill)
                    } else {
                        ImageView(url: viewModel.currentSite.defaultImageURL, aspectRatio: 1.0)
                            .frame(width: 85, height: 85)
                    }

                    VStack(alignment: .leading) {
                        Text(post.getTitle())
                            .bold()
                            .font(.headline)
                            .lineLimit(2)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(post.getAuthor())
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Text(post.getDate())
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 10)
                }
            }
            .buttonStyle(OpacityButton())

            Divider()
                .zIndex(3)
        }
        .frame(height: 85)
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(post: Post.default)
            .environmentObject(ViewModelData.default)
    }
}
