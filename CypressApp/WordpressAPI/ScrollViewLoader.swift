//
//  ScrollViewLoader.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import Foundation
import Alamofire

class ScrollViewLoader: ObservableObject {
    @Published var posts = [Post]()
    var isLoadingPage: Bool {
        return currentRequest != nil
    }
    @Published var error: String?
    @Published var shouldKeepReloading = true
    var per_page = 20
    var currentPage = 1
    var canLoadMorePages = true
    
    var site: Wordpress
    var category: Int?
    var currentRequest: Request? = nil
    
    init(site: Wordpress, category: Int? = nil) {
        self.category = category
        self.site = site
        loadMorePosts()
    }
    
    func setSite(_ site: Wordpress) {
        self.site = site
        posts = []
        currentPage = 1
        canLoadMorePages = true
        error = nil
        currentRequest?.cancel()
        currentRequest = nil
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
        currentRequest = site.getPostPage(category: category, page: currentPage, per_page: per_page, embed: true) { result in
            switch result {
            case .success(let posts):
                if posts.count == 0 {
                    self.canLoadMorePages = false
                    break
                }
                self.posts += posts
                self.currentPage += 1
            case .failure(let error):
                self.error = error.errorDescription
            }
            self.currentRequest = nil
        }
    }
}
