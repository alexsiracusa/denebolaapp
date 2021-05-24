//
//  PodcastRow.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import SwiftUI

struct PodcastRow: View {
    @EnvironmentObject var player: PlayerObject
    var podcast: PodcastData
    
    var body: some View {
        NavigationLink(destination:
            PodcastDetailView(podcast: podcast)
        ) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(podcast.title)
                        .foregroundColor(.black)
                        .font(.headline)
                        .lineLimit(2)
                    Text(podcast.date)
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(podcast.description)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .background(podcast == player.currentPodcast ? Color.blue : Color.white)
                Spacer()
            }
            .frame(height: 100)
        }
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow(podcast: PodcastData.default)
            .environmentObject(PlayerObject())
    }
}
