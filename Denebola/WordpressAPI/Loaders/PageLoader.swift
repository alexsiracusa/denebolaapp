//
//  PageLoader.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import Alamofire
import Foundation
import PromiseKit

class PageLoaderManager<Loader: PageLoader>: ObservableObject {
    var pageLoader: Loader!
    private var currentPage = 1
    private var reachedEnd = false

    @Published var items: [Loader.Item] = []
    @Published var loadingPage: Bool = false
    @Published var lastError: Error?

    init(_ pageLoader: Loader?) {
        self.pageLoader = pageLoader
    }

    func loadNextPage() {
        if reachedEnd || loadingPage {
            return
        }

        loadingPage = true

        pageLoader.loadPage(currentPage).done { items in
            self.items.append(contentsOf: items)
            self.currentPage += 1
        }.ensure {
            self.loadingPage = false
        }.catch { error in
            if let error = error as? PageLoadError, case .endOfResults = error {
                self.reachedEnd = true
            } else {
                self.lastError = error
            }
        }
    }

    func reset() {
        reachedEnd = false
        currentPage = 1
        items = []
        loadingPage = false
        lastError = nil
    }

    func prefix(_ maxLength: Int) -> ArraySlice<Loader.Item> {
        return items.prefix(maxLength)
    }

    func count() -> Int {
        return items.count
    }

    func pagesLoadedCount() -> Int {
        return currentPage - 1
    }
}

protocol PageLoader {
    associatedtype Item: Identifiable

    func loadPage(_ page: Int) -> Promise<[Item]>
}

enum PageLoadError: Error {
    case network(AFError)
    case endOfResults
}
