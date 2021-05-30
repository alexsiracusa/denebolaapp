//
//  SearchView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var handler: APIHandler
    @ObservedObject var loader: SearchResultLoader
    @EnvironmentObject private var viewModel: ViewModelData
    @State var searchFor = ""
    @State var updateSearch = ""
    var category: Categories?

    init(category: Categories? = nil) {
        loader = SearchResultLoader(category: category?.id)
        self.category = category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(updateSearch: $updateSearch)
            Divider()
            
            //results
            ScrollView {
                SearchResults(category: loader.category, searchFor: $updateSearch)
            }
        }
        //.padding([.leading, .trailing])
        .navigationBarTitle("Search \(category?.name ?? "Posts")", displayMode: .inline)
        .navigationBarItems(trailing: LogoButton())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(category: .opinions)
            .environmentObject(APIHandler())
    }
}
