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
    //@EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State var podcasts: [Podcast]
    @State var currentPodcast: Podcast? = nil
    @State var episodes = [PodcastEpisode]()
    @State var loadingAsset: AVAsset! = nil
    
    @State var time = 0.0
    @State var audioLength = 0.0
    @State var seeking = false
    @EnvironmentObject var player: PlayerObject
    
    @State var showingFullDescription = false
    
    var playing: Bool {
        self.player.playing
    }

    var audioPlayer: AVPlayer {
        return self.player.player
    }

    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 30))
    }
    
    func seek(to: Double) {
        self.audioPlayer.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(to))) { _ in
            seeking = false
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if podcasts.count > 0 {
                    VStack(alignment: .leading, spacing: 0) {
                        if loader.loaded == true {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .top) {
                                    ImageView(url: URL(string: loader.podcastImageURL)!)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(5)
                                    Picker(selection: $currentPodcast,
                                        label:
                                            Text(loader.podcastTitle)
                                            .font(.headline)
                                            .foregroundColor(.black),
                                        content: {
                                        ForEach(podcasts) {podcast in
                                            Text(podcast.rssUrl)
                                                .tag(podcast as Podcast?)
                                        }
                                    })
                                    .pickerStyle(MenuPickerStyle())
                                    .disabled(podcasts.count == 1)
                                    .onChange(of: currentPodcast) {value in
                                        guard let podcast = currentPodcast else {
                                            return
                                        }
                                        loadPodcast(podcast)
                                    }
                                }
                                .padding(.bottom)
                                Text(loader.podcastDiscription)
                                    .lineLimit(showingFullDescription ? nil : 4)
                                    .padding(.bottom, 5)
                                toggleButton
                            }
                            .padding()
                            
                            Divider()
                            
                            ForEach(loader.episodes) { podcast in
                                PodcastRow(podcast: podcast)
                            }
                        } else {
                            Text("Loading")
                        }
                        
                    }
                } else {
                    Text("This School has no podcasts")
                }
            }
            .navigationBarTitle("Podcasts", displayMode: .inline)
        }
        .onAppear {
            load()
            loader.shouldKeepReloading = true
        }
        .onDisappear {
            loader.shouldKeepReloading = false
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
    
    func load() {
        if loader.loaded {
            self.episodes = loader.episodes
        } else {
            if currentPodcast == nil {
                currentPodcast = podcasts[0]
            }
            if !loader.loaded {
                if podcasts.count > 0 {
                    loader.setRSS(podcasts[0].rssUrl)
                    currentPodcast = podcasts[0]
                    loader.load()
                }
            }
        }
    }
    
    func loadPodcast(_ podcast: Podcast) {
        currentPodcast = podcast
        player.reset()
        loader.setRSS(podcast.rssUrl)
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView(podcasts: [Podcast.default])
            .environmentObject(PodcastLoader())
            //.environmentObject(WordpressAPIHandler())
            .environmentObject(PlayerObject())
    }
}
