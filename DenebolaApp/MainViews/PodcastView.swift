//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct PodcastView: View {
    @State var audioPlayer = AVPlayer()
    @EnvironmentObject var loader: PodcastLoader
    @EnvironmentObject var handler: APIHandler

    @State var time = 0

    func loadNewAudio(url: URL) {
        audioPlayer.pause()
        audioPlayer = AVPlayer(url: url)
        // Receive time updates
        audioPlayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 2), // 1/2 seconds
            queue: DispatchQueue.main,
            using: {
                self.time = Int($0.seconds)
            }
        )
    }

    var body: some View {
        NavigationView {
            ScrollView {
                Button {
                    self.audioPlayer.play()
                } label: {
                    Text("Play")
                }
                Button {
                    self.audioPlayer.pause()
                } label: {
                    Text("Pause")
                }
                Text(String(format: "%02d:%02d", time / 60, time % 60))
                ForEach(loader.podcasts) { podcast in
                    HStack(alignment: .top) {
                        if let url = podcast.imageURL {
                            ImageView(url: url)
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                                .cornerRadius(5)
                                .padding(.leading, 5)
                        }
                        Button {
                            self.loadNewAudio(url: podcast.audioURL!)
                            self.audioPlayer.play()
                        } label: {
                            Text(podcast.title!)
                                .foregroundColor(.black)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Denebacast", displayMode: .inline)
            .navigationBarItems(
                trailing: ToolbarLogo()
            )
        }
        .onAppear {
            self.loadNewAudio(url: URL(string: "https://cdn.discordapp.com/attachments/254443423568887809/396343613870571520/favorite_song.mp3")!)
            loader.load()
        }
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
            .environmentObject(PodcastLoader())
            .environmentObject(APIHandler())
    }
}
