//
//  CategoryView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/21/21.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    var category: SimpleCategory
    var imageURL: URL

    @State var isActive = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CategoryBanner(category: category, imageURL: imageURL)
                Text("Latest Posts")
                    .font(.headline)
                    .padding(.leading)
                PostFeed(site: viewModel.currentSite, loader: IncrementalLoader(WordpressPageLoader(viewModel.currentSite, category: category)))
            }

            // Navigation Link to SearchView
            // need to do like this to avoid bugs
            NavigationLink(
                destination: SearchView(loader: IncrementalLoader(WordpressSearchLoader(viewModel.currentSite, category: category))),
                isActive: $isActive,
                label: { EmptyView() }
            )
        }
        .navigationBarTitle(category.name, displayMode: .inline)
        .navigationBarItems(
            trailing:
            HStack(spacing: 15) {
                Button {
                    self.isActive = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                }
                SiteLogo(url: viewModel.currentSite.logoURL)
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: SimpleCategory(id: 7, name: "Opinions", image: nil), imageURL: Wordpress.default.defaultImageURL)
            .environmentObject(ViewModelData.default)
    }
}