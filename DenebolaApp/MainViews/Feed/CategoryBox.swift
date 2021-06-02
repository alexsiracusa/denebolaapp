//
//  CategoryBox.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/1/21.
//

import SwiftUI

struct CategoryBox: View {
    let size: CGFloat = 135
    let category: Categories
    var style: FeedStyle = .normal
    var id: Int {
        return category.id
    }
    var name: String {
        return category.name
    }
    var image: Image {
        return category.image
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    Text(name)
                        .bold()
                        .font(.headline)
                        .padding(5)
                        .foregroundColor(.black)
                }
                .zIndex(2)
                NavigationLink(destination:
                    CategoryView(category: category, style: style)
                ) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .brightness(0.3)
                }
            }
        }
        .frame(width: size, height: 55)
    }
}

struct CategoryBox_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBox(category: .opinions)
    }
}
