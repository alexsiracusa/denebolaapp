//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var handler: APIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State var selectedCategory: Int? = nil
    var style: FeedStyle = .normal
    var categoriesStyle = CategoriesStyle.image

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    CategoriesList(style: categoriesStyle, feedStyle: style)
                    
                    Spacer(minLength: 15)

                    Text("Latest Posts")
                        .font(.headline)
                        .padding(.leading)

                    Spacer(minLength: 15)

                    PostFeed(category: nil, style: style)
                }
                .padding([.top, .bottom], 15)
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarItems(
                trailing:
                HStack(spacing: 15) {
                    NavigationLink(destination:
                        SearchView()
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    LogoButton()
                }
            )
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(APIHandler())
    }
}
