//
//  CategoryButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryButton: View {
    @EnvironmentObject var viewModel: ViewModelData

    let size: CGFloat = 100
    let category: SimpleCategory

    var imageURL: URL {
        category.imageURL ?? viewModel.selectedWordpress.defaultImageURL
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
                    ImageView(url: imageURL)
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
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()
                .cornerRadius(10)
                .zIndex(1)
                .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.7), endPoint: .bottom)
                    .cornerRadius(10)
                    .opacity(0.3)
                )
        )
    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: SimpleCategory(id: 7, name: "Opinions", image: nil))
            .environmentObject(ViewModelData())
    }
}
