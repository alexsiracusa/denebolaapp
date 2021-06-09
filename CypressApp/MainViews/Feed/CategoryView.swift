//
//  CategoryView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/21/21.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData
    @EnvironmentObject var siteImages: SiteImages
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
                PostFeed(category: category.id, domain: handler.domain)
            }

            // Navigation Link to SearchView
            // need to do like this to avoid bugs
            NavigationLink(
                destination: SearchView(category: category, domain: handler.domain),
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
                LogoButton(url: siteImages.logoURL)
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: SimpleCategory(id: 7, name: "Opinions", image: nil), imageURL: SiteImages().defaultImageURL)
            .environmentObject(WordpressAPIHandler())
            .environmentObject(SiteImages())
    }
}