//
//  PostPreviewPages.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/13/21.
//

import SwiftUI

struct PostPreviewPages: View {
    var posts: [PostRow]
    
    var body: some View {
        ZStack {
            if posts.count > 0 {
                PageView(pages: posts.map { post in
                    PostPreview(post: post)
                        .padding(.horizontal, 10.0)
                })
                    .id(UUID()) // Reset selected page to 1
            
            } else {
                PlaceholderBackground()
                DefaultLoader()
            }
        }
    }
}

private struct PostPreview: View {
    var post: PostRow
    
    var image: ImageView? {
        post.fullImageURL.flatMap { ImageView(url: $0) }
    }
    
    var body: some View {
        NavigationLink(destination:
            PostView(id: post.id, title: post.title, image: image, author: post.author)
        ) {
            GeometryReader { reader in
                if let imageURL = post.fullImageURL {
                    ImageView(url: imageURL)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: reader.size.width, height: reader.size.height)
                        .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.75), endPoint: .bottom)
                            .cornerRadius(10)
                            .opacity(0.25)
                        )
                    
                } else {
                    PlaceholderImage()
                }
                
                // Text Description
                VStack(alignment: .leading) {
                    Spacer()
                    Text(post.title)
                    Text("\(post.author)  \(post.date)")
                }
                .foregroundColor(.white)
                .padding([.leading, .bottom, .trailing], 6.0)
            }
            .clipShape(RoundedRectangle(cornerRadius: 7.0))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
