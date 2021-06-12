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
            ZStack {
                PlaceholderBackground()
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(30)
                DefaultLoader()
                    .scaleEffect(0.1)
            }
        } else {
            NavigationLink(destination:
                PodcastDetailView(podcast: podcast)
            ) {
                ImageView(url: podcast.titleImageURL!, aspectRatio: 1.0)
                    .cornerRadius(30)
            }
        }
    }
}

struct PodcastImage_Previews: PreviewProvider {
    static var previews: some View {
        PodcastButton(podcast: LoadedPodcast.default)
    }
}
