//
//  CategoriesText.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoriesButton: View {
    let backgroundRect: some View = RoundedRectangle(cornerRadius: 1000, style: .circular).foregroundColor(Color.gray)
    
    var body: some View {
        HStack {
            Image(systemName: "paperplane.circle")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Categories")
        }
        .padding([.top, .bottom], 8)
        .padding([.leading, .trailing], 15)
        .background(backgroundRect.brightness(0.3))
            
    }
}

struct CategoriesButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesButton()
    }
}
