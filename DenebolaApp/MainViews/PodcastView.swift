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
    @EnvironmentObject var handler: APIHandler
    @EnvironmentObject private var viewModel: ViewModelData

    @State var podcasts = [PodcastData]()
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
                    
            ScrollView() {
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
                                    .foregroundColor(.secondary)
                            }
                            .padding(.bottom)
                            Text(loader.podcastDiscription)
                                .lineLimit(showingFullDescription ? nil : 4)
                                .padding(.bottom, 5)
                            if !showingFullDescription {
                                Button {
                                    showingFullDescription = true
                                } label: {
                                    Text("Show More")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    ForEach(podcasts) { podcast in
                        PodcastRow(podcast: podcast)
                    }
                }
            }
            .navigationBarTitle("Denebacast", displayMode: .inline)
            .navigationBarItems(trailing:
                Button {
                    viewModel.selectedTab = 1
                } label: {
                    ToolbarLogo()
                }
            )
            
        }
        .onAppear {
            if loader.loaded {
                self.podcasts = loader.podcasts
            } else {
                loader.load { podcasts in
                    self.podcasts = podcasts
                }
            }
        }
    }
}
    

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
            .environmentObject(PodcastLoader())
            .environmentObject(APIHandler())
            .environmentObject(PlayerObject())
    }
}
