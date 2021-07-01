//
//  ScrollViewLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Alamofire
import Foundation

class ScrollViewLoader: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoadingPage: Bool = false
    @Published var error: String?
    @Published var shouldKeepReloading = true
    var per_page = 20
    var currentPage = 1
    var canLoadMorePages = true

    var site: Wordpress
    var category: SimpleCategory?
    var currentRequest: Request? {
        didSet {
            isLoadingPage = currentRequest != nil
        }
    }

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
    }

    func resume() {
        currentRequest?.resume()
    }

    func loadMorePosts() {
        guard currentRequest == nil, canLoadMorePages else { return }
        currentRequest = site.getPostPage(category: category?.id, page: currentPage, per_page: per_page, embed: true) { result in
            switch result {
            case let .success(posts):
                if posts.count == 0 {
                    self.canLoadMorePages = false
                    break
                }
                self.posts += posts
                self.currentPage += 1
            case let .failure(error):
                if error.isExplicitlyCancelledError {
                    print("REQUEST CANCELLED")
                    break
                }
                self.error = error.errorDescription
            }
            self.currentRequest = nil
        }
    }
}
