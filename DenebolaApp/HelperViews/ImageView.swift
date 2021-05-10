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
            ZStack {
                PlaceholderBackground()
                    .onAppear { image.load(url) }
                DefaultLoader()
                    .scaleEffect(0.1)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!)
    }
}
