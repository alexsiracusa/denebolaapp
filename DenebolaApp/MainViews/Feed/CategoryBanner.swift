//
//  CategoryBanner.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/21/21.
//

import SwiftUI

struct CategoryBanner: View {
    let category: SimpleCategory
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .overlay(
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: UnitPoint(x: 0.5, y: 0.6), endPoint: .bottom)
                .opacity(0.25)
            )
            .overlay(
                HStack {
                    VStack {
                        Spacer()
                        Text(category.name)
                            .bold()
                            .font(.system(size: 35, weight: .bold, design: .default))
                            .padding(5)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            )
    }
}

struct CategoryBanner_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBanner(category: SimpleCategory(id: 7, name: "Opinions", image: nil), image: Image("DenebolaLogo"))
    }
}
