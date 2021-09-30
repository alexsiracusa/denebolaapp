//
//  SearchView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @State var loader: IncrementalLoader<WordpressSearchLoader>
    @State var updateSearch = ""

    init(loader: IncrementalLoader<WordpressSearchLoader>) {
        self.loader = loader
    }

    func onRefresh(_ refreshDone: @escaping () -> Void) {
        loader.refreshNonRemoving()
            .refreshTimeout()
            .catch(viewModel.handleError(context: "Refresh failed."))
            .finally(refreshDone)
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(loader: loader, updateSearch: $updateSearch)

            Divider()

            // Initialized but user didn't
            ScrollView {
                if updateSearch != "" {
                    SearchResults(loader: loader)
                }
            }
        }
        .onChange(of: updateSearch) { newValue in
            if updateSearch == "" || updateSearch == loader.pageLoader.searchTerm { return }
            loader.reset()
            loader.pageLoader.setSearchTerm(searchTerm: newValue)
            loader.loadNextPage().catch(viewModel.handleError(context: "Search failed"))
        }
        .onAppear {
            self.updateSearch = loader.pageLoader.searchTerm
        }
        .navigationBarTitle("Search \(loader.pageLoader.category?.name ?? "Posts")", displayMode: .inline)
        .navigationBarItems(trailing: SiteLogo(url: viewModel.currentSite.logoURL))
        .pullToRefresh(viewModel.getRefreshModifier(for: "search", callback: onRefresh))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(loader: IncrementalLoader(WordpressSearchLoader(Wordpress.default, category: SimpleCategory(id: 7, name: "Opinions", image: nil))))
            .environmentObject(ViewModelData.default)
    }
}
