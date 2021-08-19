//
//  PodcastSection.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import SwiftUI
import UIKit

struct PodcastSection: View {
    @EnvironmentObject private var viewModel: ViewModelData
    let podcast: Podcast

    var loaded: LoadedPodcast? {
        viewModel.loadedPodcasts[podcast.id]
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom) {
                    Text(loaded?.title ?? "Loading")
                        .font(.system(size: 23, weight: .bold, design: .default))
                        .bold()
                        .lineLimit(1)

                    Spacer()

                    if let loaded = loaded {
                        NavigationLink(destination:
                            PodcastDetailView(podcast: loaded)
                        ) {
                            Text(" ")
                                .font(.system(size: 23))
                                + Text("Show More")
                        }
                    } else {
                        Text(" ")
                            .font(.system(size: 23))
                            + Text("Show More")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.trailing, 15)
                .padding(.vertical, 10)
            }
            .padding(.leading, 15)

            if let loaded = loaded {
                ForEach(loaded.episodes.prefix(2)) { episode in
                    SmallEpisodeRow(episode: episode)
                }
            } else {
                ForEach(0 ..< 2) { _ in
                    LoadingSmallEpisodeRow()
                }
                .onAppear {
                    viewModel.loadPodcast(podcast).done {}.catch { _ in }
                }
            }

            Divider()
                .padding(.top, 35)
                .padding(.leading, 15)
        }
    }
}

struct PodcastSection_Previews: PreviewProvider {
    static var previews: some View {
        PodcastSection(podcast: Podcast.default)
            .environmentObject(ViewModelData.default)
            .environmentObject(PlayerObject.default)
    }
}
