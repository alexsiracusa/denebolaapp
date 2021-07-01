//
//  PostSection.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/19/21.
//

import SwiftUI

struct PostSection: View {
    @EnvironmentObject private var viewModel: ViewModelData

    var posts: [Post]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Latest Posts")
                .foregroundColor(.red)
                .font(.title)
                .fontWeight(.black)
                .padding(.bottom)

            if posts.count > 0 {
                VStack {
                    PostCard(post: posts[0], textSize: .title2)

                    HStack(alignment: .top) {
                        PostCard(post: posts[1], textSize: .subheadline)
                        PostCard(post: posts[2], textSize: .subheadline)
                    }

                    PostRowView(post: posts[3])
                    PostRowView(post: posts[4])
                }
            }

            Button(action: {
                viewModel.selectedTab = 2
            }) {
                HStack {
                    Spacer()
                    Text("MORE NEWS")
                        .font(.subheadline)
                        .bold()
                        .frame(alignment: .trailing)
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.system(size: 10))
                }
            }

            .foregroundColor(.red)
        }
        .padding([.leading, .trailing], 15)
        .padding(.bottom, 20)
    }
}

struct PostSection_Previews: PreviewProvider {
    static var previews: some View {
        PostSection(posts: [Post.default, Post.default, Post.default, Post.default, Post.default, Post.default])
            .environmentObject(ViewModelData())
    }
}
