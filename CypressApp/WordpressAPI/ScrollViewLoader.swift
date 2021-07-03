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
    
    var isLoadingPage: Bool { self.currentRequest != nil }

    var per_page = 20
    var currentPage = 1
    var canLoadMorePages = true

    var site: Wordpress
    var category: SimpleCategory?
    @Published var currentRequest: CancellablePromise<[Post]>?

    init(site: Wordpress, category: SimpleCategory? = nil) {
        self.category = category
        self.site = site
        self.loadMorePosts()
    }

    func setSite(_ site: Wordpress) {
        self.site = site
        self.posts = []
        self.currentPage = 1
        self.canLoadMorePages = true
        self.currentRequest?.cancel()
        self.currentRequest = nil
        self.error = nil
        self.loadMorePosts()
    }

    func loadMorePostsIfNeeded(currentItem: Post) {
        let index = self.posts.firstIndex(where: { currentItem.id == $0.id })
        let thresholdIndex = self.posts.index(self.posts.endIndex, offsetBy: -self.per_page)
        if index == thresholdIndex {
            self.loadMorePosts()
        }
    }

    func cancel() {
        self.currentRequest?.cancel()
        self.currentRequest = nil
    }

    func loadMorePosts() {
        guard self.canLoadMorePages else { return }

        self.currentRequest = self.site.getPostPage(category: self.category?.id, page: self.currentPage, per_page: self.per_page, embed: true)

        self.currentRequest!.done { posts in
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
