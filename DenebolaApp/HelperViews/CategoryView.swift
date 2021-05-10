//
//  CategoryView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import SwiftUI

struct CategoryView: View {
    let id: Int
    let name: String

    var body: some View {
        Text(name)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(id: 7, name: "Opinions")
    }
}
