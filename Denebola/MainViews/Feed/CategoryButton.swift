//
//  StaticCategoryButton.swift
//  CypressApp
//
//  Created by Alex Siracusa on 8/19/21.
//

import SwiftUI

struct CategoryButton: View {
    let size: CGFloat = 90
    let category: SimpleCategory
    let defaultImageURL: URL

    var imageURL: URL {
        category.imageURL ?? defaultImageURL
    }

    var body: some View {
        NavigationLink(destination:
            CategoryView(category: category, imageURL: imageURL)
        ) {
            ZStack(alignment: .bottomLeading) {
                Text(category.name)
                    .bold()
                    .font(.caption)
                    .padding(5)
                    .foregroundColor(.white)
                    .zIndex(2)
                ImageView(url: imageURL, aspectRatio: 1.0)
                    .frame(width: size, height: size)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black]),
                            startPoint: UnitPoint(x: 0.5, y: 0.7),
                            endPoint: .bottom
                        )
                        .opacity(0.3)
                    )
                    .cornerRadius(10)
                    .zIndex(1)
            }
        }
        .buttonStyle(ScaleButton())
        .frame(width: size, height: size)
    }
}

struct StaticCategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: SimpleCategory(id: 7, name: "Opinions", image: nil), defaultImageURL: Wordpress.default.defaultImageURL)
    }
}
