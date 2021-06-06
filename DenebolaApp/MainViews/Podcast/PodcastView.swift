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
    @EnvironmentObject var handler: WordpressAPIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State var podcasts: [Podcast]
    @State var episodes = [PodcastEpisode]()
    @State var currentPodcast: Podcast? = nil
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
                                    Text(loader.podcastTitle)
                                        .font(.headline)
                                        .bold()
                                }
                                .padding(.bottom)
                                Text(loader.podcastDiscription)
                                    .lineLimit(showingFullDescription ? nil : 4)
                                    .padding(.bottom, 5)
                                Button {
                                    showingFullDescription.toggle()
                                } label: {
                                    Text(showingFullDescription ? "Show Less" : "Show More")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                        }
                        
                        Divider()
                        
                        ForEach(loader.episodes) { podcast in
                            PodcastRow(podcast: podcast)
                        }
                    }
                } else {
                    Text("This School has no podcasts")
                }
            }
            .navigationBarTitle("Denebacast", displayMode: .inline)
        }
        .onAppear {
            if loader.loaded {
                self.episodes = loader.episodes
            } else {
                if podcasts.count > 0 {
                    loader.setRSS(podcasts[0].rssUrl)
                    loader.load()
                }
            }
        }
    }
}
    
struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView(podcasts: [Podcast.default])
            .environmentObject(PodcastLoader())
            .environmentObject(WordpressAPIHandler())
            .environmentObject(PlayerObject())
    }
}
