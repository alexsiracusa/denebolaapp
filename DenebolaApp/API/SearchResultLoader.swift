//
//  SearchResultLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import Foundation

class SearchResultLoader: ScrollViewLoader {
    private var search: String = ""
    
    func searchFor(_ text: String, category: Int? = nil) {
        posts = [PostRow]()
        isLoadingPage = false
        canLoadMorePages = true
        error = nil
        self.category = category
        currentPage = 1
        self.search = text
        loadMorePosts()
    }
    
    override func loadMorePosts() {
        guard !isLoadingPage, canLoadMorePages else { return }
        guard search != "" else { return }
        isLoadingPage = true
        handler.searchPosts(category: category, text: search, page: currentPage, per_page: per_page, embed: true) { posts, error in
            self.error = error
            guard let posts = posts else {
                self.canLoadMorePages = false
                return
            }
            let newPosts = posts.map { $0.asPostRow() }
            self.posts += newPosts
            self.currentPage += 1
            self.isLoadingPage = false
        }
    }
}
