//
//  SearchRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/22/21.
//

import SwiftUI

struct SearchRow: View {
    let postRow: PostRow
    
    var body: some View {
        Text(postRow.title)
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(postRow: PostRow.default)
    }
}
