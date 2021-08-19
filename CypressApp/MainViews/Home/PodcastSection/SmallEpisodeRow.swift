//
//  SmallPodcastRow.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/30/21.
//

import PromiseKit
import SwiftUI

struct SmallEpisodeRow: View {
    @EnvironmentObject var player: PlayerObject
    @EnvironmentObject var viewModel: ViewModelData
    let episode: PodcastEpisode

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
            HStack(alignment: .center, spacing: 0) {
                if let url = episode.imageURL {
                    ImageView(url: url, aspectRatio: 1.0)
                        .frame(width: 85, height: 85)
                        .cornerRadius(8)
                        .padding(15)
                } else {
                    PlaceHolderImage()
                        .frame(width: 85, height: 85)
                        .cornerRadius(8)
                        .padding(15)
                }

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

                    Spacer(minLength: 0)
                }
                .padding(.top, 15)
                Spacer(minLength: 0)
            }
            .padding(.trailing, 15)
            .frame(height: 100)
        }
        .buttonStyle(OpacityButton())
        .disabled(player.loading)
    }
}

struct SmallPodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        SmallEpisodeRow(episode: PodcastEpisode.default)
            .environmentObject(PlayerObject.default)
            .environmentObject(ViewModelData.default)
    }
}
