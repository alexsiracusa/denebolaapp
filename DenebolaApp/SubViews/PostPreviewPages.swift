//
//  PostPreviewPages.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/13/21.
//

import SwiftUI

struct PostPreviewInfo {
    let tag: String
    let row: PostRow
}

struct PostPreviewPages: View {
    var posts: [PostPreviewInfo]
    
    var body: some View {
        ZStack {
            if posts.count > 0 {
                PageView(pages: posts.map { post in
                    PostPreview(post: post.row, tag: post.tag)
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
    let post: PostRow
    let tag: String?
    
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
                        .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .bottom)
                            .cornerRadius(10)
                            .opacity(0.5)
                        )
                    
                } else {
                    PlaceholderImage()
                }
                
                // Text Description
                VStack(alignment: .leading) {
                    Spacer()
                    
                    if let tag = tag {
                        Text(tag)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5.0)
                            .fixedSize()
                            .background(RoundedRectangle(cornerRadius: 3.0).fill(Color.red))
                    }
                    
                    Text(post.title)
                    Text("\(post.author ?? "")  \(post.date)")
                }
                .foregroundColor(.white)
                .padding([.leading, .trailing])
                .padding(.bottom, 20.0)
            }
            .clipShape(RoundedRectangle(cornerRadius: 7.0))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
