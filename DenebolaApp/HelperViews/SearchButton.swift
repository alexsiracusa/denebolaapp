//
//  SearchButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct SearchButton: View {
    let backgroundRect: some View = RoundedRectangle(cornerRadius: 1000, style: .circular).foregroundColor(Color.gray)
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass.circle")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Search")
                .font(.headline)
        }
        .padding([.top, .bottom], 8)
        .padding([.leading, .trailing], 15)
        .background(backgroundRect.brightness(0.3))
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton()
    }
}
