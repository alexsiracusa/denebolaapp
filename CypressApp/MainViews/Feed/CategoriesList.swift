//
//  CategoriesList.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoriesList: View {
    let site: Wordpress
    let categories: [SimpleCategory]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(categories) { category in
                    CategoryButton(site: site, category: category)
                }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList(site: Wordpress.default, categories: Wordpress.default.featuredCategories)
            .environmentObject(SiteImages())
    }
}
