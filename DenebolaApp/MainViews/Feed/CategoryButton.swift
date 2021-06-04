//
//  CategoryButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryButton: View {
    @EnvironmentObject var defaultImage: DefaultImage
    let size: CGFloat = 100
    let category: SimpleCategory
    var name: String {
        return category.name
    }

    var body: some View {
        ZStack {
            GeometryReader { _ in
                VStack {
                    Spacer()
                    Text(name)
                        .bold()
                        .font(.caption)
                        .padding(5)
                        .foregroundColor(.white)
                }
                .zIndex(2)
                NavigationLink(destination:
                    CategoryView(category: category, imageURL: category.imageURL == nil ? defaultImage.imageURL : category.imageURL!)
                ) {
                    if let url = category.imageURL {
                        ImageView(url: url)
                            .asCategoryButton(size: size)
                    } else {
                        ImageView(url: self.defaultImage.imageURL)
                            .asCategoryButton(size: size)
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
        }
    }
}

extension View {
    func asCategoryButton(size: CGFloat) -> AnyView {
        AnyView(
            self
                .scaledToFill()
                .frame(width: size, height: size)
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()
                .cornerRadius(10)
                .zIndex(1)
                .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.8), endPoint: .bottom)
                    .cornerRadius(10)
                    .opacity(0.25)
                )
        )
    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: SimpleCategory(id: 7, name: "Opinions", image: nil))
            .environmentObject(DefaultImage())
    }
}
