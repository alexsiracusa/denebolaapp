//
//  PostView.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/19/21.
//

import LoaderUI
import SwiftUI

struct PostView: View {
    // @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject var viewModel: ViewModelData

    let post: Post

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // image
                if let imageUrl = post.getFeaturedImageUrl() {
                    ImageView(url: imageUrl)
                        .scaledToFill()
                }

                Group {
                    // title
                    Text(post.getTitle())
                        .font(.largeTitle)
                        .bold()
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(post.getDate())
                        .fontWeight(.light)
                        .padding(.bottom, 5)

                    PostContentView(post: post)
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(post.getTitle())
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.default)
            // .environmentObject(WordpressAPIHandler())
            .environmentObject(ViewModelData())
    }
}
