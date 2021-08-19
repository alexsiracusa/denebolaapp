//
//  LogoButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/4/21.
//

import SwiftUI

struct LogoButton: View {
    let url: URL

    var body: some View {
        NavigationLink(destination: AboutView()) {
            ImageView(url: url, aspectRatio: 1.0, isCircle: true)
                .frame(width: 30, height: 30)
        }
    }
}

struct LogoButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoButton(url: Wordpress.default.logoURL)
    }
}
