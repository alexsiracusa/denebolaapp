//
//  CategoryButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryButton: View {
    let size: CGFloat = 95.0
    let id: Int
    let name: String
    let image: Image
    
    let onSelect: () -> Void

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
                
                Button(action: onSelect) {
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
    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(id: 7, name: "Opinions", image: Image("DenebolaLogo"), onSelect: {})
    }
}
