//
//  CacheView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/29/21.
//

import Disk
import SwiftUI

struct CacheView: View {
    var body: some View {
        VStack {
            Button {
                try? Disk.clear(.caches)
            } label: {
                Text("Clear")
            }
            Spacer()
        }
        .navigationBarTitle("Cache", displayMode: .inline)
    }
}

struct CacheView_Previews: PreviewProvider {
    static var previews: some View {
        CacheView()
    }
}
