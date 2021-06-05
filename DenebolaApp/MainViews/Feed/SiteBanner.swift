//
//  SiteBanner.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/5/21.
//

import SwiftUI

struct SiteBanner: View {
    let site: Wordpress
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ImageView(url: site.defaultImageURL!)
                .scaledToFill()
                .frame(height: 60)
                .aspectRatio(6.0, contentMode: .fit)
                .cornerRadius(10.0)
                .padding([.leading, .trailing])
                .tag(site as Wordpress?)
        }
    }
}

struct SiteBanner_Previews: PreviewProvider {
    static var previews: some View {
        SiteBanner(site: Wordpress.default)
    }
}
