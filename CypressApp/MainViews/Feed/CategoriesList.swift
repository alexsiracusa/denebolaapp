//
//  StaticCategoriesList.swift
//  CypressApp
//
//  Created by Alex Siracusa on 8/19/21.
//

import SwiftUI

struct CategoriesList: View {
    let site: Wordpress

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(site.featuredCategories) { category in
                    CategoryButton(category: category, defaultImageURL: site.defaultImageURL)
                }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}

struct StaticCategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList(site: Wordpress.default)
    }
}
