//
//  LogoButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/4/21.
//

import SwiftUI

struct SiteLogo: View {
    let url: URL

    var body: some View {
        ImageView(url: url, aspectRatio: 1.0, isCircle: true)
            .frame(width: 30, height: 30)
    }
}

struct LogoButton_Previews: PreviewProvider {
    static var previews: some View {
        SiteLogo(url: Wordpress.default.logoURL)
    }
}
