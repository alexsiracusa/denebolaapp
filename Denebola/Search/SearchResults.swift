//
//  SearchResults.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchResults: View {
    @ObservedObject var loader: SearchResultLoader
    @Binding var searchFor: String

    init(loader: SearchResultLoader, searchFor: Binding<String>) {
        _searchFor = searchFor
        self.loader = loader
    }

    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack(spacing: 0) {
                ForEach(loader.posts) { post in
                    SearchRow(post: post)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: post)
                        }
                }
            }
            .onChange(of: searchFor) { search in
                loader.searchFor(search)
            }
        } else {
            Group {
                if let error = loader.error {
                    Text(error)
                        .onChange(of: searchFor) { search in
                            loader.searchFor(search)
                        }
                        .padding()
                } else if loader.isLoadingPage {
                    // TODO: make better loading screen
                    Text("Loading")
                        .padding()
                } else {
                    Text("No Results")
                        .onChange(of: searchFor) { search in
                            loader.searchFor(search)
                        }
                        .padding()
                }
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(loader: SearchResultLoader(site: Wordpress.default), searchFor: .constant(""))
        // .environmentObject(WordpressAPIHandler())
    }
}
