//
//  SearchRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchRow: View {
    let postRow: PostRow
    
    var fullImage: ImageView? {
        postRow.fullImageURL.flatMap { ImageView(url: $0) }
    }
    
    var title: String {
        return postRow.title
    }

    var author: String {
        return postRow.author ?? ""
    }

    var date: String {
        return postRow.date
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                if postRow.hasMedia && postRow.thumbnailImageURL != nil {
                    ImageView(url: postRow.thumbnailImageURL!)
                        .scaledToFill()
                        .frame(width: 136, height: 85)
                        .clipped()
                        .aspectRatio(1.6, contentMode: .fill)
                }  else {
                    Image("DenebolaLogo")
                        .resizable()
                        .frame(width: 85, height: 85)
                }
                NavigationLink(destination:
                    PostView(id: postRow.id, title: postRow.title, image: fullImage, author: postRow.author)
                        .navigationBarTitle(Text(""), displayMode: .inline)
                ) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .bold()
                            .font(.headline)
                            .lineLimit(2)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(author)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Text(date)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
                Spacer()
            }
            Divider()
                .zIndex(3)
        }
        .frame(height: 85)
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(postRow: PostRow.default)
    }
}
