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
    var style: FeedStyle = .normal
    
    @State var isActive = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CategoryBanner(category: category)
                Text("Latest Posts")
                    .font(.headline)
                    .padding(.leading)
                PostFeed(category: category.id, style: style)
            }
            
            //Navigation Link to SearchView
            //need to do like this to avoid bugs
            NavigationLink(
                destination: SearchView(category: category),
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
        CategoryView(category: .arts)
            .environmentObject(APIHandler())
    }
}
