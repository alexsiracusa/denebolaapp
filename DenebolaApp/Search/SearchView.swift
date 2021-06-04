//
//  SearchView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @ObservedObject var loader: SearchResultLoader
    @EnvironmentObject private var viewModel: ViewModelData
    @State var searchFor = ""
    @State var updateSearch = ""
    var category: SimpleCategory?

    init(category: SimpleCategory? = nil, domain: String) {
        self.category = category
        loader = SearchResultLoader(domain: domain, category: category?.id)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(updateSearch: $updateSearch)
            Divider()
            
            //results
            ScrollView {
                SearchResults(category: loader.category, domain: handler.domain, searchFor: $updateSearch)
            }
        }
        //.padding([.leading, .trailing])
        .navigationBarTitle("Search \(category?.name ?? "Posts")", displayMode: .inline)
        .navigationBarItems(trailing: LogoButton())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(category: SimpleCategory(id: 7, name: "Opinions", image: nil), domain: "https://nshsdenebola.com")
            .environmentObject(WordpressAPIHandler())
    }
}
