//
//  PodcastImage.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import SwiftUI

struct PodcastButton: View {
    let podcast: LoadedPodcast
    
    var body: some View {
        if podcast.isEmpty() {
            VStack(alignment: .leading, spacing: 5) {
                ZStack {
                    PlaceholderBackground()
                        .aspectRatio(1.0, contentMode: .fit)
                    DefaultLoader()
                        .scaleEffect(0.1)
                }
                Text("")
                    .font(Font.custom("headline", size: 10))
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
        } else {
            NavigationLink(destination:
                PodcastDetailView(podcast: podcast)
            ) {
                VStack(alignment: .leading, spacing: 5) {
                    ImageView(url: podcast.titleImageURL!, aspectRatio: 1.0)
                    Text(podcast.title)
                        .font(Font.custom("headline", size: 10))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct PodcastImage_Previews: PreviewProvider {
    static var previews: some View {
        PodcastButton(podcast: LoadedPodcast.default)
    }
}
