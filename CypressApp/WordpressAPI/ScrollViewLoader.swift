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
    @Published var shouldKeepReloading = true
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
        handler = WordpressAPIHandler(domain: domain)
        posts = []
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
        let loadingDomain = handler.domain
        handler.loadPostPage(category: category, page: currentPage, per_page: per_page, embed: true) { posts, error in
            self.isLoadingPage = false
            self.error = error
            guard error == nil else {
                if self.shouldKeepReloading {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.loadMorePosts()
                    }
                }
                return
            }
            guard let posts = posts else {
                return
            }
            guard posts.count > 0 else {
                self.canLoadMorePages = false
                return
            }
            if loadingDomain == self.handler.domain {
                self.posts += posts
                self.currentPage += 1
            }
        }
    }
}
