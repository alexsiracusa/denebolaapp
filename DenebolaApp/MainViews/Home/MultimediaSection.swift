//
//  MultimediaSection.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/20/21.
//

import SwiftUI

struct MultimediaSection: View {
    @EnvironmentObject private var viewModel: ViewModelData
    
    var posts: [PostRow]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Multimedia")
                .foregroundColor(.green)
                .font(.title)
                .fontWeight(.black)
                .padding(.bottom)
            
            VStack(spacing: 20) {
                ForEach(posts) { post in
                    PostCard(post: post, textSize: .title2)
                }
            }
            
            Button(action: {
                viewModel.selectedTab = 2
            }) {
                HStack {
                    Spacer()
                    Text("MORE MULTIMEDIA")
                        .font(.subheadline)
                        .bold()
                        .frame(alignment: .trailing)
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.system(size: 10))
                }
            }
            
            .foregroundColor(.green)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct MultimediaSection_Previews: PreviewProvider {
    static var previews: some View {
        MultimediaSection(posts: [PostRow.default, PostRow.default])
    }
}
