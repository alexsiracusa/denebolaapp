//
//  ImageView.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/8/21.
//

import Nuke
import SwiftUI

struct ImageView: View {
    @StateObject private var image = FetchImage()
    let url: URL
    var shouldReset: Bool = false
    var aspectRatio: CGFloat?
    var isCircle = false

    func setup() {
        if image.onFailure != nil { return }
        image.onFailure = { _ in
            // Retry loading image after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                image.load(url)
            }
        }
    }

    func load(_ url: URL) {
        image.load(url)
    }

    func ImageBody() -> some View {
        ZStack {
            if let view = image.view {
                view
                    .resizable()

            } else {
                if isCircle {
                    LoadingRectangle()
                        .cornerRadius(999)
                } else {
                    LoadingRectangle()
                }
            }
        }
    }

    var body: some View {
        Group {
            if let aspectRatio = aspectRatio {
                Rectangle()
                    .fill(Color.clear)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .overlay(
                        GeometryReader { geo in
                            ImageBody()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.width / aspectRatio)
                                .clipped()
                        }
                    )
            } else {
                ImageBody()
                    .scaledToFit()
            }
        }
        .onChange(of: url, perform: load)
        .onAppear {
            load(url)
            setup()
        }
        .onDisappear {
            if shouldReset {
                image.reset()
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: try! "https://designshack.net/wp-content/uploads/placeholder-image.png".asURL())
    }
}
