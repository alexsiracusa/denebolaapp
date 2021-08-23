//
//  SearchResultLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import Foundation

class SearchResultLoader: ScrollViewLoader {
    @Published var search: String = ""

    func searchFor(_ text: String, category: SimpleCategory? = nil) {
        posts = [Post]()
        currentRequest?.cancel()
        currentRequest = nil
        canLoadMorePages = true
        error = nil

        self.category = category ?? self.category

        currentPage = 1
        search = text
        loadMorePosts()
    }

    override func loadMorePosts() {
        guard canLoadMorePages else { return }

        guard search != "" else {
            posts = []
            return
        }

        currentRequest = site.searchPosts(category: category?.id, text: search, page: currentPage, per_page: per_page, embed: true)

        currentRequest!.done { posts in
            if posts.count == 0 {
                self.canLoadMorePages = false
            }
            self.posts += posts
            self.currentPage += 1
        }.catch { error in
            self.error = error.localizedDescription
        }.finally {
            self.currentRequest = nil
        }
    }
}
