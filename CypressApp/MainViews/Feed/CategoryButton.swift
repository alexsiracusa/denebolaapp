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
        ZStack {
            GeometryReader { _ in
                VStack {
                    Spacer()
                    Text(category.name)
                        .bold()
                        .font(.caption)
                        .padding(5)
                        .foregroundColor(.white)
                }
                .zIndex(2)
                NavigationLink(destination:
                    CategoryView(category: category, imageURL: imageURL)
                ) {
                    ImageView(url: imageURL, aspectRatio: 1.0)
                        .asCategoryButton(size: size)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

extension View {
    func asCategoryButton(size: CGFloat) -> AnyView {
        AnyView(
            scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(10)
                .zIndex(1)
                .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.7), endPoint: .bottom)
                    .cornerRadius(10)
                    .opacity(0.3)
                )
        )
    }
}

struct StaticCategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: SimpleCategory(id: 7, name: "Opinions", image: nil), defaultImageURL: Wordpress.default.defaultImageURL)
    }
}
