//
//  CategoriesList.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoriesList: View {
    var style : CategoriesStyle = .image
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                switch style {
                case .image:
                    ForEach(Categories.allCases, id: \.rawValue.0) { category in
                        CategoryButton(category: category)
                    }
                case .box:
                    ForEach(0..<Int((Categories.allCases.count + 1) / 2), id: \.self) { n in
                        VStack(spacing: 10) {
                            CategoryBox(category: Categories.allCases[2 * n])
                            if 2 * n + 1 < Categories.allCases.count {
                                CategoryBox(category: Categories.allCases[2 * n + 1])
                            }
                        }
                        .padding([.top, .bottom], 3)
                        .fixedSize()
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        //CategoriesList(style: .image, feedStyle: .normal)
        CategoriesList(style: .box)
    }
}
