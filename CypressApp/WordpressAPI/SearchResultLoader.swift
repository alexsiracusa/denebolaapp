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
        posts = [Post]()
        currentRequest?.cancel()
        currentRequest = nil
        canLoadMorePages = true
        error = nil
        if let category = category { self.category = category }
        currentPage = 1
        search = text
        loadMorePosts()
    }

    override func loadMorePosts() {
        guard !isLoadingPage, canLoadMorePages else { return }
        guard search != "" else {return}
        currentRequest = site.searchPosts(category: category, text: search, page: currentPage, per_page: per_page, embed: true) { result in
            switch result {
            case .success(let posts):
                if posts.count == 0 {
                    self.canLoadMorePages = false
                    self.currentPage += 1
                    break
                }
                self.posts += posts
            case .failure(let error):
                self.error = error.errorDescription
            }
        }
        
    }
}
