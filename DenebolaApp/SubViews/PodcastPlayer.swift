//
//  PodcastPlayer.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import SwiftUI
import MediaPlayer

struct PodcastPlayer: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var audioPlayer = AVPlayer()
    @ObservedObject var podcast: PodcastObject
    
    @State var time = 0.0
    @State var audioLength = 0.0
    @State var playing = false
    @State var sliding = false
    
    init(podcast: Podcast) {
        self.podcast = podcast.asObject()
        loadNewAudio(url: podcast.audioURL!)
    }

    func loadNewAudio(url: URL) {
        audioPlayer.pause()
        self.audioPlayer = AVPlayer(url: url)
        if let duration = audioPlayer.currentItem?.asset.duration {
            self.audioLength = CMTimeGetSeconds(duration)
        } else {
            self.audioLength = 0.0
        }
        // Receive time updates
        audioPlayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 2), // 1/2 seconds
            queue: DispatchQueue.main,
            using: {
                if !sliding {
                    self.time = $0.seconds
                }
            }
        )
    }
    
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
         }
         catch {
            // report for an error
         }
        audioPlayer.play()
        self.playing = true
    }
    
    func pause() {
        self.audioPlayer.pause()
        self.playing = false
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(podcast.title)
                    .padding(.leading)
                Spacer()
            }
            
            ImageView(url: podcast.imageURL!)
                .scaledToFit()
                .cornerRadius(10)
                .aspectRatio(1.0, contentMode: .fit)
                .padding([.leading, .trailing])
            Slider(value: $time, in: 0...audioLength) { editing in
                if !editing {
                    audioPlayer.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)))
                    sliding = false
                } else {
                    sliding = true
                }
            }
                .padding([.leading, .trailing])
            HStack {
                Text(String(format: "%02d:%02d", Int(time) / 60, Int(time) % 60))
                    .font(.caption)
                Spacer()
                Text(String(format: "%02d:%02d", Int(audioLength) / 60, Int(audioLength) % 60))
                    .font(.caption)
            }
            .padding([.leading, .trailing])
            HStack(spacing: 30) {
                Button {
                    audioPlayer.seek(to: CMTime(seconds: time - 15, preferredTimescale: CMTimeScale(1.0)))
                } label: {
                    Image(systemName: "gobackward.15")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Button {
                    playing.toggle()
                    if playing {
                        play()
                    } else {
                        pause()
                    }
                } label: {
                    if !playing {
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "pause.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                Button {
                    audioPlayer.seek(to: CMTime(seconds: time + 30, preferredTimescale: CMTimeScale(1.0)))
                } label: {
                    Image(systemName: "goforward.30")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .offset(y: -15)
            Spacer()
        }
        .onAppear {
            loadNewAudio(url: podcast.audioURL!)
        }
    }
}

struct PodcastPlayer_Previews: PreviewProvider {
    static var previews: some View {
        PodcastPlayer(podcast: Podcast.default)
    }
}
