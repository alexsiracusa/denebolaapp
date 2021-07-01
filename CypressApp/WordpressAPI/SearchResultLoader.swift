//
//  SearchResultLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import Foundation

class SearchResultLoader: ScrollViewLoader {
    private var search: String = ""

    func searchFor(_ text: String, category: SimpleCategory? = nil) {
        posts = [Post]()
        currentRequest?.cancel()
        currentRequest = nil
        canLoadMorePages = true
        error = nil

        self.category = category

        currentPage = 1
        search = text
        loadMorePosts()
    }

    override func loadMorePosts() {
        guard currentRequest == nil, canLoadMorePages else { return }
        guard search != "" else {
            posts = []
            return
        }
        currentRequest = site.searchPosts(category: category?.id, text: search, page: currentPage, per_page: per_page, embed: true) { result in
            switch result {
            case let .success(posts):
                if posts.count == 0 {
                    self.canLoadMorePages = false
                    break
                }
                self.posts += posts
                self.currentPage += 1
            case let .failure(error):
                self.error = error.errorDescription
            }
            self.currentRequest = nil
        }
    }
}
