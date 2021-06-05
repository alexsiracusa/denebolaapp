//
//  CategoriesList.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoriesList: View {
    let categories: [SimpleCategory]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(categories) { category in
                    CategoryButton(category: category)
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList(categories: Wordpress.default.featuredCategories)
    }
}
