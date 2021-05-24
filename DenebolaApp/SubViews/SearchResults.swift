//
//  SearchResults.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchResults: View {
    @EnvironmentObject var handler: APIHandler
    @ObservedObject var loader: SearchResultLoader
    @Binding var searchFor: String
    
    init(category: Int? = nil, searchFor: Binding<String>) {
        loader = SearchResultLoader(category: category)
        self._searchFor = searchFor
    }
    
    var body: some View {
        if loader.posts.count != 0 {
            LazyVStack(spacing: 0) {
                ForEach(loader.posts) { postRow in
                    SearchRow(postRow: postRow)
                        .onAppear {
                            loader.loadMorePostsIfNeeded(currentItem: postRow)
                        }
                }
            }
            .onChange(of: searchFor) { search in
                loader.searchFor(search)
            }
        } else {
            if let error = loader.error {
                Text(error)
                    .onChange(of: searchFor) { search in
                        loader.searchFor(search)
                    }
                    .padding()
            }
            else if loader.isLoadingPage {
                //TODO: make better loading screen
                Text("Loading")
                    .padding()
            }
            else {
                Text("No Results")
                    .onChange(of: searchFor) { search in
                        loader.searchFor(search)
                    }
                    .padding()
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(searchFor: .constant(""))
            .environmentObject(APIHandler())
    }
}