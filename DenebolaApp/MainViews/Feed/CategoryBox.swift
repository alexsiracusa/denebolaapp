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
                    CategoryView(category: category)
                ) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .brightness(0.3)
                        .shadow(color: Color.black.opacity(0.3), radius: 2.0, x: 1.0, y: 1.0)
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
