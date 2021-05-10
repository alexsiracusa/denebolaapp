//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var handler: APIHandler
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(Categories.allCases, id: \.rawValue.0) {category in
                                CategoryButton(id: category.id, name: category.name, image: category.image)
                                    .padding([.leading, .trailing], 5)
                            }
                            Rectangle()
                                .frame(width: 20)
                                .foregroundColor(.clear)
                        }
                        .padding([.leading, .trailing], 5)
                        .padding(.top, 15)
                    }
                    Spacer(minLength: 12)
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(.gray)
                        .brightness(0.3)
                    HStack {
                        Text("Recent Posts")
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer(minLength: 15)
                    PostFeed()
                }
            }
            .navigationBarTitle("Feed", displayMode: .inline)
            .navigationBarItems(
                leading:
                    ToolbarLogo()
                ,
                trailing:
                    NavigationLink(destination:
                        Search()
                    ) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
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
