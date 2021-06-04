//
//  ScrollViewLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation

class ScrollViewLoader: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoadingPage = false
    @Published var error: String?
    var per_page = 20
    var currentPage = 1
    var canLoadMorePages = true
    
    var handler: WordpressAPIHandler
    var category: Int?
    
    init(domain: String, category: Int? = nil) {
        self.category = category
        self.handler = WordpressAPIHandler(domain: domain)
        loadMorePosts()
    }
    
    func setDomain(_ domain: String) {
        self.handler = WordpressAPIHandler(domain: domain)
        currentPage = 1
        canLoadMorePages = true
        error = nil
        isLoadingPage = false
        loadMorePosts()
    }
    
    func loadMorePostsIfNeeded(currentItem: Post) {
        let index = posts.firstIndex(where: { currentItem.id == $0.id })
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -per_page)
        if index == thresholdIndex {
            loadMorePosts()
        }
    }
    
    func loadMorePosts() {
        guard !isLoadingPage, canLoadMorePages else { return }
        isLoadingPage = true
        handler.loadPostPage(category: category, page: currentPage, per_page: per_page, embed: true) { posts, error in
            self.error = error
            guard let posts = posts else {
                self.canLoadMorePages = false
                return
            }
            self.posts += posts
            self.currentPage += 1
            self.isLoadingPage = false
        }
    }
}
