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
    @State private var loadedPosts = [PostPreviewInfo]()
    
    func loadPosts() {
        var displayedIds = Set<Int>()
        
        DispatchQueue.main.async {
            for category in Categories.allCases {
                handler.loadPostPage(category: category.id, page: 1, per_page: 2, embed: true, completionHandler: { posts, _ in
                    guard let posts = posts, posts.count > 0 else {return}
                    
                    for post in posts {
                        if displayedIds.contains(post.id) {continue} // avoid duplicate posts that might have more than one category
                        
                        loadedPosts.append(PostPreviewInfo(tag: category.name, row: post.asPostRow(thumbnailSize: "large")))
                        displayedIds.insert(post.id)
                        
                        break;
                    }
                })
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Latest Posts")
                    .font(.title2)
                    .bold()
                    .padding([.top, .leading])
                
                PostPreviewPages(posts: loadedPosts)
                    .aspectRatio(1.5, contentMode: .fit)
                
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

