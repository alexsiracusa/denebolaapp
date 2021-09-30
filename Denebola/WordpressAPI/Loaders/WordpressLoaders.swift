//
//  WordpressPageLoader.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import PromiseKit
import SwiftUI

class WordpressPageLoader: PageLoader, Equatable {
    typealias Item = Post

    let site: Wordpress
    let per_page: Int
    let category: SimpleCategory?

    init(_ site: Wordpress, per_page: Int = 10, category: SimpleCategory? = nil) {
        self.site = site
        self.category = category
        self.per_page = per_page
    }

    func mapPageError(error: Error) throws -> Promise<[Item]> {
        if let error = error.asAFError {
            // code 400 marks end
            if let code = error.responseCode, code == 400 {
                throw PageLoadError.endOfResults
            }
            throw PageLoadError.network(error)
        }
        throw error
    }

    func loadPage(_ page: Int) -> Promise<[Item]> {
        return site.getPostPage(category: category?.id, page: page, per_page: per_page, embed: true).recover(mapPageError)
    }

    static func == (lhs: WordpressPageLoader, rhs: WordpressPageLoader) -> Bool {
        return lhs.site == rhs.site
    }
}

class WordpressSearchLoader: WordpressPageLoader {
    var searchTerm: String = ""

    override func loadPage(_ page: Int) -> Promise<[WordpressPageLoader.Item]> {
        return site.searchPosts(category: category?.id, text: searchTerm, page: page, per_page: per_page, embed: true).recover(mapPageError)
    }

    func setSearchTerm(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}
