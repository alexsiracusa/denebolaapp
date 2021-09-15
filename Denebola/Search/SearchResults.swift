//
//  SearchResults.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchResults: View {
    @ObservedObject var loader: IncrementalLoader<WordpressSearchLoader>

    var body: some View {
        if loader.count() > 0 {
            LazyVStack(spacing: 0) {
                ForEach(loader.items) { post in
                    SearchRow(post: post)
                        .onAppear {
                            loader.loadMoreIfNeeded(currentItem: post)
                        }
                }
            }
        } else {
            Group {
                if let error = loader.lastError {
                    Text(error.localizedDescription)
                } else if loader.loadingPage {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("No Results")
                }
            }.padding()
                .onAppear {
                    if loader.count() == 0 {
                        loader.loadNextPage()
                    }
                }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(loader: IncrementalLoader(WordpressSearchLoader(Wordpress.default)))
    }
}
