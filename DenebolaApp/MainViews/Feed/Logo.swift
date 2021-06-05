//
//  Logo.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/4/21.
//

import SwiftUI

struct Logo: View {
    @EnvironmentObject var siteImages: SiteImages
    @Binding var url: URL
    
    var body: some View {
        ImageView(url: url)
            .frame(width: 30, height: 30)
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo(url: .constant(SiteImages().logoURL))
            .environmentObject(SiteImages())
    }
}
