//
//  SearchBar.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchBar: View {
    @State var searchFor: String = ""
    @Binding var updateSearch: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 40)
            Rectangle()
                .foregroundColor(Color.gray)
                .brightness(0.35)
                .frame(height: 30)
                .cornerRadius(10)
                .padding([.leading, .trailing], 10)
            TextField(
                "Search",
                 text: $searchFor
            ) { isEditing in

            } onCommit: {
                updateSearch = searchFor
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(updateSearch: .constant(""))
    }
}
