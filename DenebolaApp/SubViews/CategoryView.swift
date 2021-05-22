//
//  CategoryView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/21/21.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var handler: APIHandler
    @EnvironmentObject private var viewModel: ViewModelData
    var category: Categories
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CategoryBanner(category: category)
                Text("Latest Posts")
                    .font(.headline)
                    .padding(.leading)
                PostFeed(category: category.id)
            }
        }
        .navigationBarTitle(category.name, displayMode: .inline)
        .navigationBarItems(trailing:
            Button {
                viewModel.selectedTab = 1
            } label: {
                ToolbarLogo()
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .arts)
            .environmentObject(APIHandler())
    }
}
