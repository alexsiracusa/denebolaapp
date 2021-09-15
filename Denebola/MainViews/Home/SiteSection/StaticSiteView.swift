//
//  StaticSiteView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 8/19/21.
//

import SwiftUI

struct StaticSiteView: View {
    let site: Wordpress
    let loader: IncrementalLoader<WordpressPageLoader>

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                SiteBanner(imageURL: site.bannerURL)
                    .padding([.leading, .trailing], 15)

                Spacer(minLength: 10)

                PostFeed(site: site, loader: loader)
            }
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
        .navigationBarTitle(site.name, displayMode: .inline)
    }
}

struct StaticSiteView_Previews: PreviewProvider {
    static var previews: some View {
        StaticSiteView(site: Wordpress.default, loader: IncrementalLoader(WordpressPageLoader(Wordpress.default)))
    }
}
