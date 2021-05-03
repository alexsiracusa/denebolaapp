//
//  ScrollViewLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation


class ScrollViewLoader: ObservableObject {
    @Published var posts = [PostRow]()
    @Published var isLoadingPage = false
    @Published var error: String?
    private var topIndex = 0
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private var handler = APIHandler()
    var category: Int?
    
    init(category: Int?) {
        self.category = category
        loadMorePosts()
    }
    
    func loadMorePostsIfNeeded(currentItem: PostRow) {
        let index = posts.firstIndex(where: {currentItem.id == $0.id})
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -5)
        if index == thresholdIndex {
            loadMorePosts()
        }
    }
    
    func loadMorePosts() {
        guard !isLoadingPage && canLoadMorePages else {return}
        isLoadingPage = true
        handler.loadPostPage(category: category, page: currentPage, per_page: 10, embed: true) { posts, error in
            self.error = error
            guard let posts = posts else {
                self.canLoadMorePages = false
                return
            }
            let newPosts = posts.map{
                return PostRow(id: $0.id, title: $0.renderedTitle, author: "Author", date: $0.date, imageURL: $0._embedded?.featuredMedia?[0].source_url, hasMedia: $0.hasMedia)
            }
            self.posts += newPosts
            self.currentPage += 1
            self.isLoadingPage = false
        }
    }
    
}
