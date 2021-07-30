//
//  CategoriesList.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoriesList: View {
    @EnvironmentObject private var viewModel: ViewModelData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(viewModel.currentSite.featuredCategories) { category in
                    CategoryButton(category: category)
                }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
            .environmentObject(ViewModelData())
    }
}
