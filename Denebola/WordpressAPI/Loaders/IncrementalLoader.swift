//
//  IncrementalLoader.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import Foundation
import SwiftUI

class IncrementalLoader<Loader: PageLoader>: PageLoaderManager<Loader> {
    func loadMoreIfNeeded(currentItem: Loader.Item) {
        let index = items.firstIndex(where: { currentItem.id == $0.id })
        let thresholdIndex = items.index(items.endIndex, offsetBy: -10)

        if index == thresholdIndex {
            loadNextPage()
        }
    }
}
