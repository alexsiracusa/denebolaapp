//
//  ImageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import SwiftUI
import FetchImage

struct ImageView: View {
    let url: URL

    @StateObject private var image = FetchImage()

    var body: some View {
        if let view = image.view {
            view
                .resizable()
                .clipped()
                .onDisappear(perform: image.reset)
        } else {
            Rectangle().fill(Color.gray)
                .onAppear { image.load(url) }
        }
    }
}

extension FetchImage {
    var displayImage: Image? {
        guard let image = self.image else {return nil}
        return Image(uiImage: image.imageWithoutBaseline())
        
    }
}


struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!)
    }
}
