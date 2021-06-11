//
//  ImageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import Nuke
import SwiftUI

struct ImageView: View {
    @StateObject private var image: FetchImage = FetchImage()
    let url: URL
    var aspectRatio: CGFloat?
    var hasAspect: Bool {
        return aspectRatio != nil
    }
    
    func setup() {
        if image.onFailure != nil {return}
        image.onFailure = {error in
            // Retry loading image after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                image.load(url)
            }
        }
    }
    
    func load(_ url: URL) {
        image.load(url)
    }

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay(
                GeometryReader { geo in
                    ZStack {
                        if let view = image.view {
                            view
                                .resizable()
                                
                        } else {
                            PlaceholderBackground()
                            DefaultLoader()
                                .scaleEffect(0.1)
                        }
                    }
                    .scaledToFill()
                    .frame(width: hasAspect ? geo.size.width : nil, height: hasAspect ? geo.size.width / aspectRatio! : nil)
                    .clipped()
                }
            )
        .onAppear { load(url); setup(); }
        .onChange(of: url, perform: load)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!, aspectRatio: 1.6)
    }
}
