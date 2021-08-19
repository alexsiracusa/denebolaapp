//
//  EpisodeDescription.swift
//  CypressApp
//
//  Created by Alex Siracusa on 7/13/21.
//

import SwiftUI

struct EpisodeDescription: View {
    @EnvironmentObject var player: PlayerObject

    var body: some View {
        if let episode = player.episode {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(episode.title)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)

                    Spacer()
                        .frame(height: 2)

                    Text(episode.from)
                        .font(.caption)
                        .foregroundColor(.black)
                        .fontWeight(.bold)

                    Text("\(episode.dateString) • \(getFormattedMinutesSeconds(player.audioLength))")
                        .foregroundColor(.black)
                        .font(.footnote)
                        .bold()

                    ContentRenderer(htmlContent: generateHtml(body: [episode.description]))

                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.top, 10)
            }
        }
    }
}

struct EpisodeDescription_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDescription()
            .environmentObject(PlayerObject.default)
    }
}
