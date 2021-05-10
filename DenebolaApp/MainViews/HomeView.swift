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
    
    @State private var selectedCategory = Categories.allCases.first!
    @State private var loadedPosts = [PostRow]()
    
    func loadPosts() {
        handler.loadPostPage(category: selectedCategory.id, page: 1, per_page: 3, embed: true, completionHandler: { post, _ in
            guard let post = post, post.count > 0 else { return }
            
            self.loadedPosts = post.map { $0.asPostRow() }
        })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CategorySelection(selectedCategory: $selectedCategory, onCategorySelected: { _ in
                    loadPosts()
                })
                
                if loadedPosts.count > 0 {
                    PageView(pages: loadedPosts.map { post in
                        PostPreviewHome(post: post)
                            .padding(.horizontal, 5.0)
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
            .navigationBarItems(
                trailing:
                ToolbarLogo()
            )
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
    
    var onCategorySelected: (Categories) -> Void = { _ in }
    
    var body: some View {
        ScrollView([.horizontal], showsIndicators: false) {
            ScrollViewReader { reader in
                HStack {
                    ForEach(Categories.allCases, id: \.id) { category in
                        Button(action: {
                            selectedCategory = category
                            onCategorySelected(category)
                            withAnimation {
                                reader.scrollTo(category.id, anchor: .center)
                            }
                        }) {
                            BubbleText(text: category.name)
                        }
                        .foregroundColor(category == selectedCategory ? .black : .secondary)
                    }
                    Spacer(minLength: 150)
                }
                .padding([.leading, .trailing, .top, .bottom], 10)
            }
        }
    }
}

private struct PostPreviewHome: View {
    var post: PostRow
    
    var image: ImageView? {
        post.imageURL.flatMap { ImageView(url: $0) }
    }
    
    var body: some View {
        NavigationLink(destination:
            PostView(id: post.id, title: post.title, image: image, author: post.author)
        ) {
            GeometryReader { reader in
                if let imageURL = post.imageURL {
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
