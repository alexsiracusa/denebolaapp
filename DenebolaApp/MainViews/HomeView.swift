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

