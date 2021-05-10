//
//  PodcastView.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/2/21.
//

import MediaPlayer
import SwiftUI

struct PodcastView: View {
    @State var audioPlayer: AVAudioPlayer!
    @EnvironmentObject var loader: PodcastLoader
    
    var body: some View {
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
            ForEach(loader.podcasts) { podcast in
                HStack(alignment: .top) {
                    if let url = podcast.imageURL {
                        ImageView(url: url)
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .aspectRatio(1, contentMode: .fit)
                            .clipped()
                            .cornerRadius(5)
                    }
                    
                    Text(podcast.title!)
                        .foregroundColor(podcast.audioURL != nil ? .green : .red)
                        .lineLimit(2)
                    Spacer()
                }
                
            }
        }
        .onAppear {
            let data = NSDataAsset(name: "alan walker - faded (ncs release) at very low quality")!.data
            self.audioPlayer = try! AVAudioPlayer(data: data)
            loader.load()
        }
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
            .environmentObject(PodcastLoader())
    }
}
