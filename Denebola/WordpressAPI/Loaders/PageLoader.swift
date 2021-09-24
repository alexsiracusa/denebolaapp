//
//  PageLoader.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import Alamofire
import Foundation
import PromiseKit

class PageLoaderManager<Loader: PageLoader & Equatable>: ObservableObject, Equatable {
    static func == (lhs: PageLoaderManager<Loader>, rhs: PageLoaderManager<Loader>) -> Bool {
        return lhs.pageLoader == rhs.pageLoader
    }

    var pageLoader: Loader!
    private var currentPage = 1
    private var reachedEnd = false

    @Published var items: [Loader.Item] = []
    @Published var loadingPage: Bool = false
    @Published var lastError: Error?

    init(_ pageLoader: Loader?) {
        self.pageLoader = pageLoader
    }
    
    func handlePageLoadError(error: Error) throws {
        if let error = error as? PageLoadError, case .endOfResults = error {
            self.reachedEnd = true
        } else {
            self.lastError = error
            throw error
        }
    }

    func loadNextPage() -> Promise<Void> {
        if reachedEnd || loadingPage {
            return Promise()
        }

        loadingPage = true

        return pageLoader.loadPage(currentPage).done { items in
            self.items.append(contentsOf: items)
            self.currentPage += 1
        }.ensure {
            self.loadingPage = false
        }
        .recover(handlePageLoadError)
    }
    
    func refreshNonRemoving() -> Promise<Void> {
        return pageLoader.loadPage(1).done {items in
            self.reset()
            self.items.append(contentsOf: items)
            self.currentPage += 1
        }
        .recover(handlePageLoadError)
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
