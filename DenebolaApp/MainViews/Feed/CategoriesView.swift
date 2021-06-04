//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData
    @EnvironmentObject var defaultImage: DefaultImage

    @State var wordpress: Wordpress
    @State var selectedCategory: Int? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    CategoriesList(categories: wordpress.featuredCategories, defaultImage: defaultImage.image)
                    
                    Spacer(minLength: 15)

                    Text("Latest Posts")
                        .font(.headline)
                        .padding(.leading)

                    Spacer(minLength: 15)

                    PostFeed(category: nil, domain: handler.domain)
                }
                .padding([.top, .bottom], 15)
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarItems(
                trailing:
                HStack(spacing: 15) {
                    NavigationLink(destination:
                        SearchView(domain: handler.domain)
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    LogoButton()
                }
            )
        }
        .onAppear {
            load()
        }
    }
    
    func load() {
        handler.domain = wordpress.url
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(wordpress: Wordpress.default)
            .environmentObject(WordpressAPIHandler())
            .environmentObject(DefaultImage())
    }
}
