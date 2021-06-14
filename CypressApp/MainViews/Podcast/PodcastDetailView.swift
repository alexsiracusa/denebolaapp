//
//  PodcastDetailView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/11/21.
//

import SwiftUI

struct PodcastDetailView: View {
    let podcast: LoadedPodcast
    @State var showingFullDescription = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        ImageView(url: podcast.titleImageURL!)
                            .frame(width: 100, height: 100)
                            .cornerRadius(5)
                        Text(podcast.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom)
                    Text(podcast.description)
                        .lineLimit(showingFullDescription ? nil : 4)
                        .padding(.bottom, 5)
                    toggleButton
                }
                .padding()

                Divider()

                LazyVStack(spacing: 0) {
                    ForEach(podcast.episodes) { podcast in
                        PodcastRow(episode: podcast)
                    }
                }
            }
        }
    }

    var toggleButton: some View {
        Button {
            withAnimation(Animation.easeInOut) {
                self.showingFullDescription.toggle()
            }
        } label: {
            Text(self.showingFullDescription ? "Show less" : "Show more")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailView(podcast: LoadedPodcast.default)
            .environmentObject(PlayerObject())
    }
}
