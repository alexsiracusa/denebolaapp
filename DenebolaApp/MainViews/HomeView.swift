//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import FetchImage
import LoaderUI
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var handler: APIHandler
    @State private var loadedPosts = [PostRow]()
    
    func loadPosts() {
        handler.loadPostPage(category: nil, page: 1, per_page: 5, embed: true, completionHandler: { post, _ in
            guard let post = post, post.count > 0 else { return }
            
            self.loadedPosts = post.map { $0.asPostRow() }
        })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Latest Posts")
                    .font(.title2)
                    .bold()
                    .padding([.top, .leading])
                
                if loadedPosts.count > 0 {
                    PageView(pages: loadedPosts.map { post in
                        PostPreviewHome(post: post)
                            .padding(.horizontal, 10.0)
                    })
                        .aspectRatio(1.5, contentMode: .fit)
                        .id(UUID()) // Reset selected page to 1
                } else {
                    PlaceholderBackground()
                    DefaultLoader()
                }
                
                Spacer()
            }
            .onAppear {
                loadPosts()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: ToolbarLogo())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(APIHandler())
    }
}

private struct PostPreviewHome: View {
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
    }
}
