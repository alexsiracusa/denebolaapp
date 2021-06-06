//
//  ImageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import Nuke
import SwiftUI

struct ImageView: View {
    let url: URL

    @StateObject private var image = FetchImage()
    var aspectRatio: CGFloat?

    func load(_ url: URL) {
        image.load(url)
    }

    var body: some View {
        ZStack {
            if let view = image.view {
                view
                    .resizable()
                    .clipped()
            } else {
                PlaceholderBackground()
                DefaultLoader()
                    .scaleEffect(0.1)
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .onAppear { load(url) }
        .onChange(of: url, perform: load)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!, aspectRatio: 1.6)
    }
}
