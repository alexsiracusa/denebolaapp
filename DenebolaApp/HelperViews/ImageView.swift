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
        ZStack {
            Rectangle().fill(Color.gray)
            image.view?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
        .onAppear { image.load(url) }
        .onDisappear(perform: image.reset)
    }
}


struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: URL(string: "https://designshack.net/wp-content/uploads/placeholder-image.png")!)
    }
}
