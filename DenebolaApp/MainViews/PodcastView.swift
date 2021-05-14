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
    @State var currentPodcast = PodcastData.default {
        didSet {
            self.beginNewAudio(url: self.currentPodcast.audioURL!)
        }
    }

    //@Binding var audioPlayer: AVPlayer// = AVPlayer()
    @State var podcasts = [PodcastData]()
    @State var loadingAsset: AVAsset! = nil
    
    @State var time = 0.0
    @State var audioLength = 0.0
    //@Binding var playing: Bool
    @State var seeking = false
    @ObservedObject var player: PlayerObject
    var playing: Bool {
        player.playing
    }
    var audioPlayer: AVPlayer {
        return player.player
    }
    init(player: PlayerObject) {
        self.player = player
        self.audioPlayer.automaticallyWaitsToMinimizeStalling = false
    }
    
    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 30))
    }
    
    func seek(to: Double) {
        audioPlayer.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(to))) {_ in 
            seeking = false
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { value in
                ScrollView {
                    // Current Podcast
                    VStack {
                        HStack {
                            Text(currentPodcast.title)
                                .padding(.leading)
                            Spacer()
                        }
                        
                        ImageView(url: currentPodcast.imageURL!)
                            .scaledToFit()
                            .cornerRadius(10)
                            .aspectRatio(1.0, contentMode: .fit)
                            .padding([.leading, .trailing])
                        
                        Slider(value: $time, in: 0 ... audioLength) { editing in
                            if !editing {
                                seek(to: time)
                            } else {
                                seeking = true
                            }
                        }
                        .padding([.leading, .trailing])
                        
                        HStack {
                            Text(getFormattedMinutesSeconds(time))
                                .font(.caption)
                            Spacer()
                            Text(getFormattedMinutesSeconds(audioLength))
                                .font(.caption)
                        }
                        .padding([.leading, .trailing])
                        
                        HStack(spacing: 30) {
                            Button {
                                seek(to: time - 15.0)
                            } label: {
                                MediaControlImage("gobackward.15")
                            }
                            
                            Button {
                                if playing { pause() } else { play() }
                            } label: {
                                MediaControlImage(playing ? "pause.circle" : "play.circle")
                            }
                            
                            Button {
                                seek(to: time + 30.0)
                            } label: {
                                MediaControlImage("goforward.30")
                            }
                        }
                        .offset(y: -15)
                        Spacer()
                    }
                    .id(1)
                    .padding(.top)
                    
                    // Podcast List
                    HStack {
                        Text("Episodes")
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    ForEach(podcasts) { podcast in
                        PodcastRow(podcast: podcast) {
                            withAnimation {
                                value.scrollTo(1, anchor: .top)
                            }
                            currentPodcast = podcast
                            play()
                        }
                    }
                }
                .navigationBarTitle("Denebacast", displayMode: .inline)
                .navigationBarItems(trailing: ToolbarLogo())
            }
        }
        .onAppear {
            guard !loader.loaded else { return }
            loader.load { podcasts in
                self.podcasts = podcasts
                currentPodcast = loader.podcasts[0]
            }
        }
    }
    
    func beginNewAudio(url: URL) {
        if let loadingAsset = self.loadingAsset {
            loadingAsset.cancelLoading()
        }
        
        self.loadingAsset = AVAsset(url: url)
        
        self.audioPlayer.replaceCurrentItem(with: nil)
        // Do not block the main thread loading audio
        self.loadingAsset.loadValuesAsynchronously(forKeys: ["playable"], completionHandler: {
            var error: NSError? = nil
            let status = self.loadingAsset.statusOfValue(forKey: "playable", error: &error)

            switch status {
                case .loaded:
                    DispatchQueue.main.async {
                        self.loadAsset()
                    }
                case .failed:
                    fallthrough
                case .cancelled:
                    // TODO
                    break;
                default:
                    break;
            }
        })
    }
    
    func loadAsset() {
        let item = AVPlayerItem(asset: self.loadingAsset)
        self.audioPlayer.replaceCurrentItem(with: item)
        // Get duration
        if let duration = audioPlayer.currentItem?.asset.duration {
            self.audioLength = CMTimeGetSeconds(duration)
        } else {
            self.audioLength = 0.0
        }
        // Receive time updates
        self.audioPlayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 2), // 1/2 seconds
            queue: DispatchQueue.main,
            using: {
                if !seeking {
                    self.time = $0.seconds
                }
            }
        )
    }
    
    func play() {
        self.audioPlayer.play()
        self.player.playing = true
    }
    
    func pause() {
        self.audioPlayer.pause()
        self.player.playing = false
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView(player: PlayerObject())
            .environmentObject(PodcastLoader())
            .environmentObject(APIHandler())
    }
}

private struct PodcastRow: View {
    var podcast: PodcastData
    var onSelect: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: onSelect) {
                PlayButton()
                    .padding(.leading, 5)
            }
            Button(action: onSelect) {
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
            }
            Spacer()
        }
    }
}
