//
//  CategoriesView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    CategoriesText()
                        .padding(.leading)
                }
                ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(Categories.allCases, id: \.rawValue.0) {category in
                                let id = category.rawValue.0
                                let name = category.rawValue.1
                                CategoryButton(id: id, name: name)
                                    .padding([.leading, .trailing], 5)
                            }
                            Rectangle()
                                .frame(width: 20)
                                .foregroundColor(.clear)
                        }
                        .padding([.leading, .trailing], 5)
                    }
                    Text("Categories")
                }
            }
            .padding(.top, 5)
            .navigationBarHidden(true)
            
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
