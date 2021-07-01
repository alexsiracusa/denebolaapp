//
//  SiteBanner.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/5/21.
//

import SwiftUI

struct SiteBanner: View {
    let imageURL: URL
    let aspectRatio: CGFloat = 6.0

    var body: some View {
        ImageView(url: imageURL, aspectRatio: 6.0)
            .clipped()
            .cornerRadius(10.0)
    }
}

struct SiteBanner_Previews: PreviewProvider {
    static var previews: some View {
        SiteBanner(imageURL: Wordpress.default.bannerURL)
    }
}
