//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct PodcastView: View {
    @EnvironmentObject var viewModel: ViewModelData
    @StateObject var loader: PodcastLoader

    var podcasts: [Podcast] {
        return viewModel.podcasts
    }

    @State var loadingAsset: AVAsset! = nil
    @EnvironmentObject var player: PlayerObject

    @State private var didAppear = false

    var items: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            if loader.feeds.count > 1 {
                VStack(spacing: 10) {
                    ForEach(loader.loadedFeeds) { podcast in
                        PodcastRow(podcast: podcast)
                    }
                }
                .lineSpacing(5)
                .padding(10)
            } else if loader.feeds.count == 1 {
                if !loader.loadedFeeds[0].isEmpty() {
                    PodcastDetailView(podcast: loader.loadedFeeds[0])
                } else {
                    Text("loading")
                }
            } else {
                Text("This school has no podcasts, something went wrong")
            }
        }
        .navigationBarTitle("Podcasts", displayMode: .inline)
        .onChange(of: viewModel.podcasts, perform: { podcasts in
            self.loader.setFeeds(podcasts.map { $0.rssUrl })
        })
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView(loader: PodcastLoader.default)
            .environmentObject(ViewModelData.default)
            .environmentObject(PlayerObject())
    }
}
