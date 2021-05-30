//
//  PageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    var usePageIndicator = false
    @Binding var currentPage: Int

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)

            if usePageIndicator {
                PageControl(numberOfPages: pages.count, currentPage: $currentPage)
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: [Color.blue, Color.red], currentPage: .constant(0))
    }
}
