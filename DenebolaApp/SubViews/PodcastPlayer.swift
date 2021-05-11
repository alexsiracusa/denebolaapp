//
//  PodcastPlayer.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/10/21.
//

import SwiftUI
import MediaPlayer

struct PodcastPlayer: View {
    @State var audioPlayer = AVPlayer()
    var podcast: Podcast
    
    @State var time = 0.0
    @State var audioLength = 0.0
    @State var playing = false

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
                self.time = $0.seconds
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
            ImageView(url: podcast.imageURL!)
                .scaledToFit()
                .cornerRadius(10)
                .aspectRatio(1.0, contentMode: .fit)
                .padding([.leading, .trailing])
            Slider(value: $time, in: 0...audioLength) { editing in
                if !editing {
                    audioPlayer.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0)))
                    audioPlayer.addPeriodicTimeObserver(
                        forInterval: CMTimeMake(value: 1, timescale: 2), // 1/2 seconds
                        queue: DispatchQueue.main,
                        using: {
                            self.time = $0.seconds
                        }
                    )
                } else {
                    
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
            
            Button {
                playing.toggle()
                if playing {
                    play()
                    audioPlayer.seek(to: CMTime(seconds: 30, preferredTimescale: CMTimeScale(1.0)))
                } else {
                    pause()
                }
            } label: {
                if !playing {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top, 30)
                } else {
                    Image(systemName: "pause.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top, 30)
                }
            }
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
