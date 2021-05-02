//
//  CategoryButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryButton: View {
    let size: CGFloat = 125.0
    let id: Int
    let name: String
    
    var body: some View {
        NavigationLink( destination:
            CategoryView(id: id, name: name)
        ) {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Text(name)
                            .bold()
                            .padding(5)
                            .foregroundColor(.white)
                    }
                    .zIndex(2)
                    Image("RamenPanda")
                        .resizable()
                        .cornerRadius(10)
                        .zIndex(1)
                }
            }
            .frame(width: size, height: size)
        }

    }
}

struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(id: 7, name: "Opinions")
    }
}
