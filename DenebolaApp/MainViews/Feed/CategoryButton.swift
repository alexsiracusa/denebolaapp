//
//  CategoryButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryButton: View {
    let size: CGFloat = 100
    let category: SimpleCategory
    @State var image: Image
    var id: Int {
        return category.id
    }
    var name: String {
        return category.name
    }
    var imageURL: URL {
        guard let strURL = category.image?.url else {
            return URL(string: "")!
        }
        guard let url = URL(string: strURL) else {
            return URL(string: "")!
        }
        return url
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
                    CategoryView(category: category)
                ) {
                    image
                        .resizable()
                        .cornerRadius(10)
                        .zIndex(1)
                        .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.8), endPoint: .bottom)
                            .cornerRadius(10)
                            .opacity(0.25)
                            // .brightness(0.7)
                        )
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if let url = category.imageURL {
                JSONLoader.loadImage(url: url) {image, error in
                    guard let image = image else {return}
                    self.image = image
                }
            }
        }
    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(category: SimpleCategory(id: 7, name: "Opinions", image: nil), image: Image("DenebolaLogo"))
    }
}
