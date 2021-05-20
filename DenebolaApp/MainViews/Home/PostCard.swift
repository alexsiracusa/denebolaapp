//
//  PostCard.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/19/21.
//

import SwiftUI
import LoaderUI
import FetchImage

struct PostCard: View {
    let post: PostRow
    let textSize: Font
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageView(url: post.thumbnailImageURL!, aspectRatio: 1.6)
                .cornerRadius(5)
                .fixedSize(horizontal: false, vertical: true)
            Text(post.title)
                .bold()
                .font(textSize)
            Text(post.date)
        }
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        PostCard(post: PostRow.default, textSize: .subheadline)
            .environmentObject(APIHandler())
    }
}
