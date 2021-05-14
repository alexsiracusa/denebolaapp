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
        var displayedIds = Set<Int>()
        
        
            handler.loadPostPage(category: nil, page: 1, per_page: 5, embed: true, completionHandler: { posts, _ in
                guard let posts = posts, posts.count > 0 else {return}
                
                loadedPosts = posts.map {$0.asPostRow(thumbnailSize: "large")}
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
                    Group {
                        PostCard(post: loadedPosts[0], textSize: .title2)
                        
                        HStack {
                            PostCard(post: loadedPosts[1], textSize: .subheadline)
                            PostCard(post: loadedPosts[2], textSize: .subheadline)
                        }
                        
                        PostRowView(postRow: loadedPosts[3], style: .normal)
                        
                    }.padding(.horizontal)
                }
                
                
                Spacer()
            }
            .onAppear {
                if loadedPosts.count == 0 {
                    loadPosts()
                }
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


struct PostCard: View {
    let post: PostRow
    let textSize: Font
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageView(url: post.thumbnailImageURL!)
                .aspectRatio(1.6, contentMode: .fit)
                .clipped()
            
            Text(post.title)
                .bold()
                .font(textSize)
            
            Text(post.date)
        }
    }
}
