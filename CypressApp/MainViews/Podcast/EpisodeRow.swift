//
//  EpisodeRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import PromiseKit
import SwiftUI

struct EpisodeRow: View {
    @EnvironmentObject var player: PlayerObject
    @EnvironmentObject var viewModel: ViewModelData

    var episode: PodcastEpisode

    var body: some View {
        Button {
            player.setAudio(episode)
            player.play()
            after(seconds: 0.1).done {
                withAnimation {
                    viewModel.podcastExpanded = true
                }
            }
        } label: {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(episode.title)
                            .foregroundColor(.black)
                            .font(.headline)
                            .lineSpacing(0)
                            .lineLimit(2)
                        Text(episode.dateString + " • " + (episode.lengthString ?? "-"))
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(height: 80)
                Divider()
            }
        }
        .buttonStyle(OpacityButton())
        .disabled(player.loading)
    }
}

struct EpisodeRow_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeRow(episode: PodcastEpisode.default)
            .environmentObject(PlayerObject.default)
            .environmentObject(ViewModelData.default)
    }
}
