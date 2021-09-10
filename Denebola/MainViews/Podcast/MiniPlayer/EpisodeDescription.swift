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
        VStack(alignment: .leading, spacing: 0) {
            // title
            HStack {
                Spacer(minLength: 0)
                VStack(spacing: 6) {
                    Image(systemName: "info.circle")
                    Text("Episode Description")
                        .font(.headline)
                        .bold()
                }
                .padding(.vertical, 12)
                Spacer(minLength: 0)
            }
            .background(Color(UIColor.lightGray).opacity(0.15))

            Divider()

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
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
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
