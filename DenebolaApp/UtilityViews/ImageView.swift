//
//  ImageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import FetchImage
import SwiftUI

struct ImageView: View {
    var url: URL

    @StateObject private var image = FetchImage()
    var aspectRatio: CGFloat? = nil

    var body: some View {
        if let view = image.view {
            view
                .resizable()
                .onDisappear(perform: image.reset)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .clipped()
                .onChange(of: url, perform: { value in
                    image.reset()
                })
        } else {
            ZStack {
                PlaceholderBackground()
                DefaultLoader()
                    .scaleEffect(0.1)
            }
            .aspectRatio(aspectRatio, contentMode: .fit)
            .onAppear {
                image.load(url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    image.load(url)
                }
            }
        }
    }
    
    func update(url: URL) {
        image.load(url)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!, aspectRatio: 1.6)
    }
}
