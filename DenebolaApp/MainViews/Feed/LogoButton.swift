//
//  LogoButton.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/4/21.
//

import SwiftUI

struct LogoButton: View {
    @EnvironmentObject var siteImages: SiteImages
    
    var body: some View {
        NavigationLink(destination: AboutView()) {
            Logo()
        }
    }
}

struct LogoButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoButton()
            .environmentObject(SiteImages())
    }
}
