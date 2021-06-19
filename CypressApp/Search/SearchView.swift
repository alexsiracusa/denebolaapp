//
//  SearchView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchView: View {
    //@EnvironmentObject var handler: WordpressAPIHandler
    @ObservedObject var loader: SearchResultLoader
    @EnvironmentObject private var viewModel: ViewModelData
    @State var searchFor = ""
    @State var updateSearch = ""
    var category: SimpleCategory?

    init(site: Wordpress, category: SimpleCategory? = nil) {
        self.category = category
        loader = SearchResultLoader(site: site, category: category)
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(updateSearch: $updateSearch)
            Divider()

            // results
            ScrollView {
                SearchResults(loader: loader, searchFor: $updateSearch)
            }
        }
        .navigationBarTitle("Search \(category?.name ?? "Posts")", displayMode: .inline)
        .navigationBarItems(trailing: LogoButton(url: viewModel.selectedWordpress.logoURL))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(site: Wordpress.default, category: SimpleCategory(id: 7, name: "Opinions", image: nil))
            //.environmentObject(WordpressAPIHandler())
            .environmentObject(ViewModelData())
    }
}
