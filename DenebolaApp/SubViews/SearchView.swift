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

    init(category: Int? = nil) {
        loader = SearchResultLoader()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(updateSearch: $updateSearch)
            Divider()
            
            //results
            ScrollView {
                SearchResults(searchFor: $updateSearch)
            }
        }
        //.padding([.leading, .trailing])
        .navigationBarTitle("Feed", displayMode: .inline)
        .navigationBarItems(trailing:
            Button {
                viewModel.selectedTab = 1
            } label: {
                ToolbarLogo()
            }
        )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(APIHandler())
    }
}
