//
//  PodcastRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import SwiftUI

struct PodcastRow: View {
    @EnvironmentObject var player: PlayerObject
    @EnvironmentObject var viewModel: ViewModelData

    var episode: PodcastEpisode

    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 60))
    }

    var body: some View {
        Button {
            player.setAudio(episode)
            player.play()
            viewModel.podcastViewState = .showFullScreen
        } label: {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(episode.title)
                            .foregroundColor(.black)
                            .font(.headline)
                            .lineLimit(2)
                        Text(episode.dateString)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(height: 80)
                Divider()
            }
        }
        .disabled(player.loading)
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow(episode: PodcastEpisode.default)
            .environmentObject(PlayerObject())
            .environmentObject(ViewModelData())
    }
}
