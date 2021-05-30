//
//  PodcastDetailView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/23/21.
//

import SwiftUI
import MediaPlayer

struct PodcastDetailView: View {
    @EnvironmentObject private var viewModel: ViewModelData
    @State var podcast: PodcastData {
        didSet {
            self.beginNewAudio(url: self.podcast.audioURL!)
        }
    }
    @EnvironmentObject var player: PlayerObject
    @State var loadingAsset: AVAsset! = nil
    
    @State var time = 0.0
    @State var audioLength = 0.0
    @State var seeking = false
    
    @State var playing = false

    var audioPlayer: AVPlayer {
        return self.player.player
    }
    
    func MediaControlImage(_ name: String) -> some View {
        return Image(systemName: name)
            .font(.system(size: 30))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                ImageView(url: podcast.imageURL!)
                    .scaledToFit()
                    .cornerRadius(10)
                    .aspectRatio(1.0, contentMode: .fit)
                
                Slider(value: $time, in: 0 ... audioLength) { editing in
                    if !editing {
                        seek(to: time)
                    } else {
                        seeking = true
                    }
                }
                .disabled(podcast != player.currentPodcast)
                
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
                    .disabled(podcast != player.currentPodcast)
                    
                    Button {
                        if playing { pause() } else { play() }
                    } label: {
                        MediaControlImage(playing ? "pause.circle" : "play.circle")
                            .onChange(of: player.playing) { value in
                                playing = value
                            }
                    }
                    
                    Button {
                        seek(to: time + 30.0)
                    } label: {
                        MediaControlImage("goforward.30")
                    }
                    .disabled(podcast != player.currentPodcast)
                }
                .offset(y: -10)
                HStack {
                    Text(podcast.title)
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                .padding(.bottom, 1)
                HStack {
                    Text(podcast.date)
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Text(podcast.description)
                    Spacer()
                }
                //Spacer()
            }
            .padding(.top)
            .padding(.bottom, 30)
        }
        .padding([.leading, .trailing])
        .onAppear {
            if podcast == player.currentPodcast {
                self.playing = player.playing
                self.time = player.player.currentTime().seconds
                self.audioLength = player.player.currentItem!.asset.duration.seconds
                self.loadingAsset = player.player.currentItem!.asset
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
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: LogoButton())
    }
    
    func seek(to: Double) {
        self.audioPlayer.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(to))) { _ in
            seeking = false
        }
        self.time = to
    }
    
    func beginNewAudio(url: URL) {
        if let loadingAsset = self.loadingAsset {
            loadingAsset.cancelLoading()
        }
        
        self.loadingAsset = AVAsset(url: url)
        self.player.currentPodcast = podcast
        
        self.audioPlayer.replaceCurrentItem(with: nil)
        // Do not block the main thread loading audio
        self.loadingAsset.loadValuesAsynchronously(forKeys: ["playable"], completionHandler: {
            var error: NSError?
            let status = self.loadingAsset.statusOfValue(forKey: "playable", error: &error)

            switch status {
                case .loaded:
                    DispatchQueue.main.async {
                        self.loadAsset()
                    }
                case .failed:
                    fallthrough
                case .cancelled:
                    // TODO:
                    break
                default:
                    break
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
        if loadingAsset == nil {
            self.beginNewAudio(url: podcast.audioURL!)
        }
        self.audioPlayer.play()
        self.player.playing = true
        self.playing = true
        self.player.image = ImageView(url: self.podcast.imageURL!)
        player.showingToolbar = true
    }
    
    func pause() {
        self.audioPlayer.pause()
        self.player.playing = false
        self.playing = false
    }
}

struct PodcastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailView(podcast: PodcastData.default)
            .environmentObject(PlayerObject())
    }
}
