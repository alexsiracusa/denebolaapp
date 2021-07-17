//
//  PodcastRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/15/21.
//

import SwiftUI

struct PodcastRow: View {
    let podcast: LoadedPodcast

    var body: some View {
        if podcast.isEmpty() {
            HStack(alignment: .top) {
                LoadingRectangle(5)
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading, spacing: 12) {
                    LoadingRectangle(20)
                        .frame(width: 200, height: 10)
                    LoadingRectangle(20)
                        .frame(width: 100, height: 10)
                }
                .padding(.top, 8)
                Spacer(minLength: 0)
            }
        } else {
            NavigationLink(destination:
                PodcastDetailView(podcast: podcast)
            ) {
                HStack(alignment: .top) {
                    ImageView(url: podcast.titleImageURL!)
                        .frame(width: 100, height: 100)
                        .cornerRadius(5)
                    Text(podcast.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                }
            }
            .buttonStyle(NoButtonAnimation())
        }
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            PodcastRow(podcast: LoadedPodcast.default)
            PodcastRow(podcast: LoadedPodcast.empty())
            PodcastRow(podcast: LoadedPodcast.default)
        }
    }
}
