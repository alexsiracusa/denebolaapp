//
//  PostSection.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/19/21.
//

import SwiftUI

struct PostSection: View {
    @EnvironmentObject private var handler: APIHandler
    @State private var loadedPosts = [PostRow]()
    
    func loadPosts() {
        var displayedIds = Set<Int>()
        
        
            handler.loadPostPage(category: nil, page: 1, per_page: 5, embed: true, completionHandler: { posts, _ in
                guard let posts = posts, posts.count > 0 else {return}
                
                loadedPosts = posts.map {$0.asPostRow(thumbnailSize: "large")}
            })
        
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .bottom) {
                Text("Latest Posts")
                    .font(.title3)
                    .bold()
                    .padding([.top, .leading])
                Spacer()
                Text("Show More")
                    .font(.subheadline)
                    .padding([.top, .trailing])
            }
            
            if loadedPosts.count > 0 {
                VStack {
                    PostCard(post: loadedPosts[0], textSize: .title2)
                    
                    HStack(alignment: .top) {
                        PostCard(post: loadedPosts[1], textSize: .subheadline)
                        PostCard(post: loadedPosts[2], textSize: .subheadline)
                    }
                    
                    PostRowView(postRow: loadedPosts[3], style: .normal)
                    PostRowView(postRow: loadedPosts[4], style: .normal)
                    
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 15)
                .background(Color.white.ignoresSafeArea().cornerRadius(10))
            }
        }
        .onAppear {
            if loadedPosts.count == 0 {
                loadPosts()
            }
        }
    }
}

struct PostSection_Previews: PreviewProvider {
    static var previews: some View {
        PostSection()
            .environmentObject(APIHandler())
    }
}
