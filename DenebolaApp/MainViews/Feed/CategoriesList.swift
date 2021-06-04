//
//  CategoriesList.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoriesList: View {
    let categories: [SimpleCategory]
    let defaultImage: Image
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(categories) { category in
                    CategoryButton(category: category, image: defaultImage)
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        //CategoriesList(style: .image, feedStyle: .normal)
        CategoriesList(categories: Wordpress.default.featuredCategories, defaultImage: Image("DenebolaLogo"))
    }
}
