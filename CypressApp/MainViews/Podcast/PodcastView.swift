//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct PodcastView: View {
    @EnvironmentObject var loader: PodcastLoader
    // @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    let podcasts: [Podcast]
    @State var loadingAsset: AVAsset! = nil
    @EnvironmentObject var player: PlayerObject
    
    @State private var showingFullDescription = false
    @State private var didAppear = false
    
    init(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    func setPodcasts(_ podcasts: [Podcast]) {
        loader.setFeeds(podcasts.map { $0.rssUrl })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(loader.loadedFeeds) { podcast in
                    PodcastButton(podcast: podcast)
                }
                .padding()
            }
            .navigationBarTitle("Podcasts", displayMode: .inline)
        }
        .onAppear {
            guard !didAppear else { return }
            didAppear = true
            setPodcasts(podcasts)
        }
        .onChange(of: podcasts) { podcasts in
            setPodcasts(podcasts)
        }
    }
    
    func load() {}
    
    func loadPodcast(_ podcast: Podcast) {}
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView([Podcast(id: 0, enabled: true, rssUrl: "https://anchor.fm/s/f635e84/podcast/rss"), Podcast(id: 0, enabled: true, rssUrl: "https://atp.fm/rss")])
            .environmentObject(PodcastLoader(["https://anchor.fm/s/f635e84/podcast/rss", "https://atp.fm/rss"]))
            // .environmentObject(WordpressAPIHandler())
            .environmentObject(PlayerObject())
    }
}
