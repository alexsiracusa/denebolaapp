//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import FetchImage
import SwiftUI

struct PostRowView: View {
    let post: Post
    var style: Style = .floating

    enum Style {
        case floating
        case normal
    }

    var body: some View {
        HStack(alignment: .top) {
            if let thumbnailImageURL = post.getThumbnailSizeUrl(size: "medium") {
                ImageView(url: thumbnailImageURL)
                    .frame(width: style == .floating ? 160 : 130, height: 100)
                    .aspectRatio(style == .floating ? 1.6 : 1.3, contentMode: .fit)
                    .cornerRadius(style == .floating ? 0.0 : 5.0)
            } else {
                Image("DenebolaLogo")
                    .resizable()
                    .cornerRadius(style == .floating ? 0.0 : 5.0)
                    .frame(width: 100, height: 100)
            }

            // title + author + date
//            NavigationLink(destination:
//                PostView(post: post)
//                    .navigationBarTitle(Text(""), displayMode: .inline)
//            ) {

//            }
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
                    Spacer(minLength: 0.0)
                    Text(post.getAuthor())
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(post.getDate())
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }.padding(.vertical, 4.0)

                Spacer()
            }
        }
        .frame(height: 100)
        .cornerRadius(style == .floating ? 10.0 : 0.0)
        .background(style == .floating ?
            RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white)
            .shadow(color: Color.gray.opacity(0.3), radius: 2.0, x: 1.0, y: 1.0)
            : nil)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: Post.default)
            .environmentObject(APIHandler())
    }
}
