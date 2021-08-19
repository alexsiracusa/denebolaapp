//
//  ScrollViewLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Alamofire
import Foundation
import PromiseKit

class ScrollViewLoader: ObservableObject {
    @Published var posts = [Post]()
    @Published var error: String?
    @Published var shouldKeepReloading = true

    var isLoadingPage: Bool { currentRequest != nil }

    var per_page = 20
    var currentPage = 1
    var canLoadMorePages = true

    var site: Wordpress
    var category: SimpleCategory?
    @Published var currentRequest: CancellablePromise<[Post]>?

    init(site: Wordpress, category: SimpleCategory? = nil) {
        self.category = category
        self.site = site
        loadMorePosts()
    }

    func setSite(_ site: Wordpress) {
        self.site = site
        posts = []
        currentPage = 1
        canLoadMorePages = true
        currentRequest?.cancel()
        currentRequest = nil
        error = nil
        loadMorePosts()
    }

    func loadMorePostsIfNeeded(currentItem: Post) {
        let index = posts.firstIndex(where: { currentItem.id == $0.id })
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -per_page)
        if index == thresholdIndex {
            loadMorePosts()
        }
    }

    func cancel() {
        currentRequest?.cancel()
        currentRequest = nil
    }

    func loadMorePosts() {
        guard canLoadMorePages else { return }

        currentRequest = site.getPostPage(category: category?.id, page: currentPage, per_page: per_page, embed: true)

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
