//
//  PostRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import FetchImage
import SwiftUI

struct PostRowView: View {
    let postRow: PostRow
    var style: Style = .floating
    
    enum Style {
        case floating
        case normal
    }

    var title: String {
        return postRow.title
    }

    var author: String {
        return postRow.author
    }

    var date: String {
        return postRow.date
    }

    var thumbnailImage: ImageView? {
        postRow.thumbnailImageURL.flatMap { ImageView(url: $0) }
    }

    var fullImage: ImageView? {
        postRow.fullImageURL.flatMap { ImageView(url: $0) }
    }

    var body: some View {
        HStack(alignment: .top) {
            if postRow.hasMedia {
                thumbnailImage?
                    .scaledToFill()
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
            NavigationLink(destination:
                PostView(id: postRow.id, title: postRow.title, image: fullImage, author: postRow.author)
                    .navigationBarTitle(Text(""), displayMode: .inline)
            ) {
                VStack(alignment: .leading) {
                    // title
                    Text(title)
                        .bold()
                        .font(.title3)
                        .lineLimit(nil)
                        .foregroundColor(.black)
                    Spacer(minLength: 0.0)
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(date)
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
                .shadow(color: Color.gray.opacity(0.3), radius: 10.0, x: 0, y: 1.0)
            : nil
        )
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        let testURL = "http://nshsdenebola.com/wp-content/uploads/2021/02/https___cdn.cnn_.com_cnnnext_dam_assets_210121163502-joe-biden.jpg".asURL

        PostRowView(postRow: PostRow(id: 1, title: "Title here long text multi line text very cool", author: "Alex Siracusa", date: "April 22, 2021", fullImageURL: testURL, thumbnailImageURL: testURL, hasMedia: true))
            .environmentObject(APIHandler())
    }
}
