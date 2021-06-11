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
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay(
                GeometryReader { geo in
                    ImageView(url: site.bannerURL!)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width / aspectRatio)
                        .clipped()
                        .cornerRadius(10.0)
                        .fixedSize()
                        .tag(site as Wordpress?)
                }
            )
        }
}

struct SiteBanner_Previews: PreviewProvider {
    static var previews: some View {
        SiteBanner(site: Wordpress.default)
    }
}
