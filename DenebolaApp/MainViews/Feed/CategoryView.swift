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
    @EnvironmentObject var defaultImage: DefaultImage
    var category: SimpleCategory
    var image: Image?
    
    @State var isActive = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CategoryBanner(category: category, image: image == nil ? defaultImage.image : image!)
                Text("Latest Posts")
                    .font(.headline)
                    .padding(.leading)
                PostFeed(category: category.id, domain: handler.domain)
            }
            
            //Navigation Link to SearchView
            //need to do like this to avoid bugs
            NavigationLink(
                destination: SearchView(category: category, domain: handler.domain),
                isActive: $isActive,
                label: { EmptyView()}
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
                LogoButton()
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: SimpleCategory(id: 7, name: "Opinions", image: nil))
            .environmentObject(WordpressAPIHandler())
            .environmentObject(DefaultImage())
    }
}
