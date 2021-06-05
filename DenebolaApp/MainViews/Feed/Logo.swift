//
//  Logo.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/4/21.
//

import SwiftUI

struct Logo: View {
    @EnvironmentObject var siteImages: SiteImages
    @State var image: Image? = nil
    
    var body: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .aspectRatio(1.0, contentMode: .fit)
        } else {
            Circle()
                .frame(width: 30, height: 30)
                .onAppear {
                    loadImage()
                }
        }
    }
    
    func loadImage() {
        JSONLoader.loadImage(url: siteImages.logoURL) {image, error in
            self.image = image
        }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
            .environmentObject(SiteImages())
    }
}
