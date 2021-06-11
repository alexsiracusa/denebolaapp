//
//  SiteBanner.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/5/21.
//

import SwiftUI

struct SiteBanner: View {
    let site: Wordpress
    let aspectRatio: CGFloat = 6.0
    
    var body: some View {
        ImageView(url: site.bannerURL!, aspectRatio: 6.0)
            .clipped()
            .cornerRadius(10.0)
            .tag(site as Wordpress?)
    }
}

struct SiteBanner_Previews: PreviewProvider {
    static var previews: some View {
        SiteBanner(site: Wordpress.default)
    }
}
