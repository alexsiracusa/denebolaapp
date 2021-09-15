//
//  WordpressPageLoader.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import PromiseKit

class WordpressPageLoader: PageLoader {
    typealias Item = Post

    let site: Wordpress
    let per_page: Int
    let category: SimpleCategory?

    init(_ site: Wordpress, per_page: Int = 10, category: SimpleCategory? = nil) {
        self.site = site
        self.category = category
        self.per_page = per_page
    }

    func mapPageError(result: Promise<[Item]>) -> Promise<[Item]> {
        return result.recover { error -> Promise<[Item]> in
            if let error = error.asAFError {
                // code 400 marks end
                if let code = error.responseCode, code == 400 {
                    throw PageLoadError.endOfResults
                }
                throw PageLoadError.network(error)
            }
            throw error
        }
    }

    func loadPage(_ page: Int) -> Promise<[Item]> {
        return site.getPostPage(category: nil, page: page, per_page: per_page, embed: true)
    }
}

class WordpressSearchLoader: WordpressPageLoader {
    var searchTerm: String = ""

    init(_ site: Wordpress, category _: SimpleCategory? = nil, per_page: Int = 10) {
        super.init(site, per_page: per_page)
    }

    override func loadPage(_ page: Int) -> Promise<[WordpressPageLoader.Item]> {
        return site.searchPosts(category: category?.id, text: searchTerm, page: page, per_page: per_page, embed: true)
    }

    func setSearchTerm(searchTerm: String) {
        self.searchTerm = searchTerm
    }
}
