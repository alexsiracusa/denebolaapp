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
            self.loadNewAudio(url: self.currentPodcast.audioURL!)
        }
    }

    @State var audioPlayer = AVPlayer()
    @State var podcasts = [PodcastData]()
    
    @State var time = 0.0
    @State var audioLength = 0.0
    @State var playing = false
    @State var sliding = false
    
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
                                audioPlayer.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(1.0))) {_ in
                                    sliding = false
                                }
                            } else {
                                sliding = true
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
                                audioPlayer.seek(to: CMTime(seconds: time - 15, preferredTimescale: CMTimeScale(1.0)))
                            } label: {
                                Image(systemName: "gobackward.15")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            if playing {
                                Button {
                                    pause()
                                } label: {
                                    Image(systemName: "pause.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            } else {
                                Button {
                                    play()
                                } label: {
                                    Image(systemName: "play.circle")
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
    
    func loadNewAudio(url: URL) {
        self.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
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
                if !sliding {
                    self.time = $0.seconds
                }
            }
        )
    }
    
    func play() {
        self.audioPlayer.play()
        self.playing = true
    }
    
    func pause() {
        self.audioPlayer.pause()
        self.playing = false
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
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
