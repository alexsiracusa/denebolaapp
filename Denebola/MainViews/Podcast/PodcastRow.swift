//
//  PodcastRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/15/21.
//

import SwiftUI

struct PodcastRow: View {
    @EnvironmentObject private var viewModel: ViewModelData
    let id: Int
    let podcast: LoadedPodcast

    var body: some View {
        NavigationLink(
            destination: PodcastDetailView(podcast: podcast),
            tag: id,
            selection: $viewModel.selectedPodcast
        ) {
            HStack(alignment: .top) {
                if let url = podcast.titleImageURL {
                    ImageView(url: url)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                } else {
                    PlaceHolderImage()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
                Text(podcast.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .buttonStyle(OpacityButton())
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            PodcastRow(id: 0, podcast: LoadedPodcast.default)
            PodcastRow(id: 1, podcast: LoadedPodcast.empty())
            PodcastRow(id: 2, podcast: LoadedPodcast.default)
        }
        .environmentObject(ViewModelData.default)
    }
}
