//
//  PodcastRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import SwiftUI

struct PodcastRow: View {
    @EnvironmentObject var player: PlayerObject
    var podcast: PodcastEpisode

    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 60))
    }

    var body: some View {
        NavigationLink(destination:
            PodcastEpisodeView(podcast: podcast)
        ) {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    if podcast == player.currentPodcast {
                        Button {
                            if player.playing {
                                player.pause()
                            } else {
                                player.play()
                            }
                        } label: {
                            MediaControlImage(player.playing ? "pause.circle" : "play.circle")
                        }
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(podcast.title)
                            .foregroundColor(.black)
                            .font(.headline)
                            .lineLimit(2)
                        Text(podcast.dateString ?? podcast.date)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(height: 80)
                Divider()
            }
            .background(
                Rectangle()
                    .fill(podcast == player.currentPodcast ? Color.gray : Color.clear)
                    .brightness(0.3)
                    .frame(height: 80)
            )
        }
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow(podcast: PodcastEpisode.default)
            .environmentObject(PlayerObject())
    }
}
