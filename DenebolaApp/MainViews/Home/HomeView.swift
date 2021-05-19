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
    
    var body: some View {
        NavigationView {
            ScrollView {
                PostSection()
                    .padding(10)
                PodcastSection()
                    .padding(10)
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: ToolbarLogo())
            .background(Color(UIColor.lightGray).ignoresSafeArea().opacity(0.2).cornerRadius(5))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(APIHandler())
    }
}


//struct PostCard: View {
//    let post: PostRow
//    let textSize: Font
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ImageView(url: post.thumbnailImageURL!, aspectRatio: 1.6)
//            Text(post.title)
//                .bold()
//                .font(textSize)
//            Text(post.date)
//        }
//    }
//}
