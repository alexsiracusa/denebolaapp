//
//  HomeView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI
import FetchImage

struct HomeView: View {
    @EnvironmentObject private var handler: APIHandler
    
    @State private var selectedCategory: Categories = Categories.allCases.first!
    @State private var loadedPosts = [PostRow]()
    
    func loadPosts() {
        handler.loadPostPage(category: selectedCategory.id, page: 1, per_page: 3, embed: true, completionHandler: {post, error in
            guard let post = post, post.count > 0 else {return}
            
            self.loadedPosts = post.map {$0.asPostRow()}
        })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CategorySelection(selectedCategory: $selectedCategory,
                                  onCategorySelected: {_ in
                                    loadPosts()
                                  })
                    .padding()
                
                
                PageView(pages: loadedPosts.map {post in
                    PostPreviewHome(post: post)
                })
                .aspectRatio(1.5, contentMode: .fit)
                .padding()
                
                Spacer()
            }
            .onAppear {
                loadPosts()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(APIHandler())
    }
}

private struct CategorySelection: View {
    @Binding var selectedCategory: Categories
    
    var onCategorySelected: (Categories) -> Void = {_ in}
    
    var body: some View {
        ScrollView([.horizontal], showsIndicators: false) {
            HStack {
                ForEach(Categories.allCases, id: \.id) { category in
                    Button(action: {
                        selectedCategory = category
                        onCategorySelected(category)
                    }) {
                        Text("\(category.name)")
                    }
                    .foregroundColor(category == selectedCategory ? .black : .gray)
                }
            }
        }
    }
}

private struct PostPreviewHome: View {
    var post: PostRow
    
    var body: some View {
        NavigationLink( destination:
            PostView(id: post.id, hasMedia: post.hasMedia, imageURL: post.imageURL, title: post.title, author: post.author)
        ) {
            GeometryReader { reader in
                ImageView(url: URL(string: post.imageURL ?? "https://designshack.net/wp-content/uploads/placeholder-image.png")!) // TODO: remove placeholder
                    .aspectRatio(contentMode: .fill)
                    .frame(width: reader.size.width, height: reader.size.height)
                    .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.75), endPoint: .bottom)
                            .cornerRadius(10)
                            .opacity(0.25)
                    )
                
                
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
