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
            VStack {
                ScrollViewReader { value in
                    ScrollView(.horizontal) {
                        Button {
                            withAnimation {
                                value.scrollTo(1, anchor: .top)
                            }
                        } label : {
                            CategoriesText()
                                .padding(.leading)
                                .padding(.bottom, 5)
                                .foregroundColor(.black)
                        }
                    }
                    ScrollView {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(Categories.allCases, id: \.rawValue.0) {category in
                                    CategoryButton(id: category.id, name: category.name)
                                        .padding([.leading, .trailing], 5)
                                }
                                Rectangle()
                                    .frame(width: 20)
                                    .foregroundColor(.clear)
                            }
                            .padding([.leading, .trailing], 5)
                        }.id(1)
                        Spacer(minLength: 12)
                        Rectangle()
                            .frame(height: 10)
                            .foregroundColor(.gray)
                            .brightness(0.3)
                        Spacer(minLength: 15)
                        PostFeed()
                    }
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
            .environmentObject(APIHandler())
    }
}
